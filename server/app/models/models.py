from pydantic import BaseModel, Field, model_serializer
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
    image_path: str | None = None
    image_thumbnail_name: str
    image_thumbnail_path: str | None = None
    key: Literal['image'] = Field(default=IMAGE_KEY, frozen=True)

    @model_serializer
    def serizlize(self):
        return {'key': IMAGE_KEY,
                'image_name': self.image_name,
                'image_thumbnail_name': self.image_thumbnail_name}

    def serialize_for_front_end(self):
        return {'key': IMAGE_KEY,
                'image_name': self.image_name,
                'image_path': self.image_path,
                'image_thumbnail_name': self.image_thumbnail_name,
                'image_thumbnail_path': self.image_thumbnail_path,
                }


