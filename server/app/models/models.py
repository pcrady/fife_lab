from pydantic import BaseModel, Field
from typing import Literal, Final


CONFIG_KEY: Final[str] = 'config'
IO_TEST_KEY: Final[str] = 'io_test'
IMAGE_KEY: Final[str] = 'image'

class Config(BaseModel):
    project_path: str
    key: Literal['config'] = Field(default=CONFIG_KEY, frozen=True)
 
 
class IOTest(BaseModel):
    test_type: str
    value: int
    key: Literal['io_test'] = Field(default=IO_TEST_KEY, frozen=True)


class AbstractImage(BaseModel):
    image_name: str
    key: Literal['image'] = Field(default=IMAGE_KEY, frozen=True)

