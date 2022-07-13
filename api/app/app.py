from email.mime import image
from fastapi import FastAPI, HTTPException, Depends, Request, File, UploadFile
from fastapi.responses import JSONResponse, FileResponse
from fastapi_jwt_auth import AuthJWT
from fastapi_jwt_auth.exceptions import AuthJWTException
from pydantic import BaseModel
from app.db import database
from fastapi.middleware.cors import CORSMiddleware
from passlib.context import CryptContext
from fastapi.security import OAuth2PasswordBearer
import time
from app.models import *
import os


ACCESS_TOKEN_EXPIRE_SECONDS = 180

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

app = FastAPI()
app.state.database = database


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.on_event("startup")
async def startup() -> None:
    database_ = app.state.database
    if not database_.is_connected:
        await database_.connect()


@app.on_event("shutdown")
async def shutdown() -> None:
    database_ = app.state.database
    if database_.is_connected:
        await database_.disconnect()


class Settings(BaseModel):
    authjwt_secret_key: str = os.environ['API_SECRET_KEY']
    authjwt_access_token_expires: int = ACCESS_TOKEN_EXPIRE_SECONDS
    authjwt_refresh_token_expires: bool = False


def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)


def get_password_hash(password):
    return pwd_context.hash(password)


# callback to get your configuration
@AuthJWT.load_config
def get_config():
    return Settings()

# exception handler for authjwt
# in production, you can tweak performance using orjson response
@app.exception_handler(AuthJWTException)
def authjwt_exception_handler(request: Request, exc: AuthJWTException):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.message}
    )


@app.post('/login')
async def login(username, password, Authorize: AuthJWT = Depends()):
    user = await User.objects.get_or_none(username=username)
    if user:
        if verify_password(password, user.hashed_password):
            access_token = Authorize.create_access_token(subject=username)
            refresh_token = Authorize.create_refresh_token(subject=username)
            # response.set_cookie(key="access_token", value={access_token}, httponly=True, secure=True)
            # response.set_cookie(key="access_token", value={access_token}, httponly=True, secure=True)
            return {"access_token": access_token,
                    "refresh_token": refresh_token,
                    "expires_at": round(time.time() + ACCESS_TOKEN_EXPIRE_SECONDS)}
        else:
            raise HTTPException(status_code=401, detail="Incorrect email or password")
    else:
        raise HTTPException(status_code=401, detail="Incorrect email or password")


@app.post('/refresh')
def refresh(authorize: AuthJWT = Depends()):
    authorize.jwt_refresh_token_required()

    current_user = authorize.get_jwt_subject()
    new_access_token = authorize.create_access_token(subject=current_user)
    refresh_token = authorize.create_refresh_token(subject=current_user)
    return {"access_token": new_access_token, "refresh_token": refresh_token, "expires_at": round(time.time() + ACCESS_TOKEN_EXPIRE_SECONDS)}


@app.post('/register', response_model=User)
async def signup(username, email, password, authorize: AuthJWT = Depends()):
    hashed_password = get_password_hash(password)
    user = User(username=username, email=email, hashed_password=hashed_password)
    await user.save()
    return user


@app.get('/user', response_model=User)
def user(Authorize: AuthJWT = Depends()):
    Authorize.jwt_required()

    current_user = Authorize.get_jwt_subject()
    return current_user


requested_coin_pair = Coin_pair.get_pydantic(exclude={'id','coin_pair_datas'})

@app.post('/add_coin_pair', response_model=Coin_pair)
async def add_coin_pair(coin_pair: requested_coin_pair):
    coin_pair = Coin_pair(**coin_pair.dict())
    coin_pair_data = await coin_pair.save()
    return coin_pair_data


@app.get('/get_all_coin_pairs', response_model=List[Coin_pair])
async def get_all_coin_pairs():
    coin_pairs = await Coin_pair.objects.select_all(follow=True).all()   
    return coin_pairs


requested_coin_pair_data = Coin_pair_data.get_pydantic(exclude={'id': ..., 'coin_pair': {'name','short_name','status', 'enabled'}})

@app.post('/add_coin_pair_data', response_model=Coin_pair_data)
async def add_coin_pair_data(coin_pair_data: requested_coin_pair_data): # type: ignore
    coin_pair_data = Coin_pair_data(**coin_pair_data.dict())
    coin_pair_data = await coin_pair_data.save()
    return coin_pair_data