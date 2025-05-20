import numpy as np
from cv2 import imreadmulti, imwrite, imread, resize, cvtColor, COLOR_RGB2BGR, INTER_AREA, IMREAD_COLOR, IMREAD_ANYCOLOR
import os
from typing import Annotated, Literal, TypeVar
import numpy.typing as npt
from pathlib import Path
from typing import List
from PIL import Image
from app.utils.app_logging import stderr_print

DType = TypeVar("DType", bound=np.generic)

ColorImage = Annotated[npt.NDArray[DType], Literal["M", "N", 3]]
GrayScaleImage = Annotated[npt.NDArray[DType], Literal["M", "N"]]
BooleanMask = Annotated[npt.NDArray[np.bool_], Literal["M", "N"]]

class ImageUtils:
    @staticmethod
    def save_scaled_image(image: np.ndarray, location: str, image_name: str, width: int = 300):
        try:
            original_height, original_width = image.shape[:2]
            scale_factor = width / original_width
            new_height = int(original_height * scale_factor)
            scaled_image = resize(image, (width, new_height), interpolation=INTER_AREA)
            file_path = os.path.join(location, image_name)
            imwrite(file_path, scaled_image)
        except Exception as e:
            stderr_print(f"[Error] Failed to save scaled image '{image_name}': {e}")
            raise


    @staticmethod
    def save_bgr_image(image: ColorImage, location: str, image_name: str):
        try:
            image_bgr = cvtColor(image, COLOR_RGB2BGR)
            file_path = os.path.join(location, image_name)
            imwrite(file_path, image_bgr)
            ImageUtils.save_scaled_image(image, location, 'thumbnail_' + image_name)
        except Exception as e:
            stderr_print(f"[Error] Failed to save BGR image '{image_name}': {e}")
            raise


    @staticmethod
    def save_rgb_image(image: ColorImage, location: str, image_name: str):
        try:
            file_path = os.path.join(location, image_name)
            imwrite(file_path, image)
            ImageUtils.save_scaled_image(image, location, 'thumbnail_' + image_name)
        except Exception as e:
            stderr_print(f"[Error] Failed to save RGB image '{image_name}': {e}")
            raise


    @staticmethod
    def convert_to_png(filepath: str, output_folder: str):
        try:
            images = []
            success, images = imreadmulti(
                mats=images,
                filename=filepath,
                flags=IMREAD_ANYCOLOR)
            if not success:
                raise ValueError("Failed to read image; it may be corrupted or the path is invalid.")

            image_number = len(images)
            base_name = os.path.basename(filepath)

            if image_number == 1:
                png_filename = os.path.splitext(base_name)[0] + '.png'
                ImageUtils.save_rgb_image(images[0], output_folder, png_filename)
            else: 
                for i in range(image_number):
                    png_filename = os.path.splitext(base_name)[0] + f"_00{i}.png"
                    ImageUtils.save_rgb_image(images[i], output_folder, png_filename)
 

        except Exception as e:
            stderr_print(f"[Error] Failed to convert image '{filepath}' to PNG: {e}")
            raise


    @staticmethod
    def verify_image(image_path: Path):
        """
        Verify that the image is not corrupted
        """
        try:
            with Image.open(image_path) as img:
                img.verify()
                return True
        except (IOError, SyntaxError):
            return False


    @staticmethod
    def verify_images(image_paths: List[Path]) -> List[str]:
        """
        Verify lists of images are not corrupted
        """
        corrupted_images = []
        for path in image_paths:
            valid = ImageUtils.verify_image(path)

            if not valid:
                corrupted_images.append(path.name)

        return corrupted_images

