from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import csv
import time


def fetch_page(driver, url):
    driver.get(url)
    return driver.page_source


def parse_product_list(driver):
    product_links = []
    driver.implicitly_wait(10)
    a_tags = driver.find_elements(By.CLASS_NAME, 'sc-pyfCe.goggFx.product__container')
    for a_tag in a_tags:
        link = a_tag.get_attribute('href')
        product_links.append(link)
    return product_links


def parse_product_details(driver):
    # 定义默认值
    product_name = product_price = manufacturer_name = general_information = product_id = common_uses = 'N/A'
    warnings = directions = image_src = ingredients = 'N/A'

    try:
        product_name = driver.find_element(By.CLASS_NAME, 'product-name').text.strip()
    except Exception as e:
        print(f"Error finding product name: {e}")

    try:
        product_price = driver.find_element(By.CLASS_NAME, 'product__price').text.strip()
    except Exception as e:
        print(f"Error finding product price: {e}")

    try:
        manufacturer_name = driver.find_element(By.CLASS_NAME, 'manufacturer-name.product-information').text.strip()
    except Exception as e:
        print(f"Error finding manufacturer name: {e}")

    try:
        common_uses = driver.find_element(By.CLASS_NAME, 'product-info-section.commonuses').text.strip()
    except Exception as e:
        print(f"Error finding common uses: {e}")

    try:
        product_id = driver.find_element(By.CLASS_NAME, 'product-id.product-information').text.strip()
    except Exception as e:
        print(f"Error finding product ID: {e}")

    try:
        general_information = driver.find_element(By.CLASS_NAME, 'product-info-section.general-info').text.strip()
    except Exception as e:
        print(f"Error finding general information: {e}")

    try:
        warnings = driver.find_element(By.CLASS_NAME, 'product-info-section.warnings').text.strip()
    except Exception as e:
        print(f"Error finding warnings: {e}")

    try:
        ingredients = driver.find_element(By.CLASS_NAME, 'product-info-section.ingredients').text.strip()
    except Exception as e:
        print(f"Error finding ingredients: {e}")

    try:
        directions = driver.find_element(By.CLASS_NAME, 'product-info-section.directions').text.strip()
    except Exception as e:
        print(f"Error finding directions: {e}")

    try:
        image_src = driver.find_element(By.CLASS_NAME, 'hero_image.zoomer_harvey.product-thumbnail').get_attribute(
            'src')
    except Exception as e:
        print(f"Error finding image src: {e}")

    return [product_name, product_price, manufacturer_name, product_id, general_information, warnings,
            common_uses, ingredients, directions, image_src]


def save_to_csv(data, filename='C:\\Users\\TZQ\\OneDrive\\桌面\\UOA\\778\\FriedChicken\\products_info.csv'):
    with open(filename, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(
            ['Product Name', 'Product Price', 'Manufacturer Name', 'Product ID', 'General Information',
             'Warnings', 'Common Use', 'Ingredients', 'Directions', 'Image Src'])
        writer.writerows(data)


def main():
    # base_url = "https://www.chemistwarehouse.co.nz/shop-online/81/vitamins-supplements"

    base_url = "https://www.chemistwarehouse.co.nz/shop-online/258/medicines"

    options = Options()
    options.headless = True  # 无头模式
    options.add_argument("--disable-notifications")  # 禁用通知
    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    all_product_links = []
    html = fetch_page(driver, base_url)

    while True:
        if html:
            product_links = parse_product_list(driver)
            all_product_links.extend(product_links)

        try:
            next_button = driver.find_element(By.CLASS_NAME, 'pager__button.pager__button--next')
            next_button.click()
            time.sleep(3)
            html = driver.page_source
        except Exception as e:
            print(f"No more pages or error finding next page button: {e}")
            break

    print(all_product_links)
    all_products_info = []
    for link in all_product_links:
        fetch_page(driver, link)
        product_info = parse_product_details(driver)
        all_products_info.append(product_info)
        time.sleep(4)

    save_to_csv(all_products_info)
    driver.quit()


if __name__ == "__main__":
    main()
