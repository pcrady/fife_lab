from pathlib import Path
import cv2
import pytest
from PIL import Image

from app.utils.image_utils import ImageUtils  # adjust if ImageUtils lives in a different module

# point this at your test_images folder
TEST_IMAGES_DIR = Path(__file__).parent / "test_images"


def test_save_scaled_image(tmp_path):
    # load a real image
    src = TEST_IMAGES_DIR / "image_ch00.png"
    img = cv2.imread(str(src), cv2.IMREAD_COLOR)
    h0, w0 = img.shape[:2]

    # scale to width=100
    ImageUtils.save_scaled_image(img, str(tmp_path), "scaled.png", width=100)
    out = tmp_path / "scaled.png"
    assert out.exists()

    # verify dimensions
    scaled = cv2.imread(str(out), cv2.IMREAD_COLOR)
    h, w = scaled.shape[:2]
    assert w == 100
    assert h == int(h0 * (100 / w0))


def test_save_rgb_image_creates_both_files(tmp_path):
    # load BGR, convert to RGB for save_rgb_image
    src = TEST_IMAGES_DIR / "image_ch01.png"
    bgr = cv2.imread(str(src), cv2.IMREAD_COLOR)
    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)

    ImageUtils.save_rgb_image(rgb, str(tmp_path), "out.png")
    img_file = tmp_path / "out.png"
    thumb    = tmp_path / "thumbnail_out.png"

    assert img_file.exists()
    assert thumb.exists()

    # thumbnail should be width=300
    thumb_img = cv2.imread(str(thumb), cv2.IMREAD_COLOR)
    assert thumb_img.shape[1] == 300


def test_save_bgr_image_creates_both_files(tmp_path):
    # load BGR, convert to RGB so that save_bgr_image will swap channels
    src = TEST_IMAGES_DIR / "image_ch02.png"
    bgr = cv2.imread(str(src), cv2.IMREAD_COLOR)
    rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)

    ImageUtils.save_bgr_image(rgb, str(tmp_path), "outbgr.png")
    img_file = tmp_path / "outbgr.png"
    thumb    = tmp_path / "thumbnail_outbgr.png"

    assert img_file.exists()
    assert thumb.exists()

    # make sure the saved file is a valid image
    with Image.open(img_file) as im:
        im.verify()  # will raise if corrupted


@pytest.mark.parametrize("tif_name", [
    "Image001_ch00_SV.tif",
    "Image001_overlay_SV.tif",
])
def test_convert_to_png_from_tif(tmp_path, tif_name):
    src = TEST_IMAGES_DIR / tif_name
    ImageUtils.convert_to_png(str(src), str(tmp_path))

    png     = tmp_path / (src.stem + ".png")
    thumb   = tmp_path / f"thumbnail_{src.stem}.png"

    assert png.exists()
    assert thumb.exists()

    # check that PIL can open them
    with Image.open(png) as im:
        im.verify()
    with Image.open(thumb) as im:
        im.verify()


def test_verify_image_true_for_good_and_false_for_bad():
    good  = TEST_IMAGES_DIR / "image_overlay.png"
    bad1  = TEST_IMAGES_DIR / "corrupted_image1.png"
    bad2  = TEST_IMAGES_DIR / "corrupted_image2.png"

    assert ImageUtils.verify_image(good) is True
    assert ImageUtils.verify_image(bad1) is False
    assert ImageUtils.verify_image(bad2) is False


def test_verify_images_lists_only_corrupted():
    paths = [
        TEST_IMAGES_DIR / "image_ch00.png",
        TEST_IMAGES_DIR / "corrupted_image1.png",
        TEST_IMAGES_DIR / "corrupted_image2.png",
    ]
    bad = ImageUtils.verify_images(paths)
    assert set(bad) == {"corrupted_image1.png", "corrupted_image2.png"}
