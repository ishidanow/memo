import requests
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import time

proxies = {
    'http': 'socks5h://localhost:9050',
    'https': 'socks5h://localhost:9050'
}

def is_onion_site_accessible(url):
    """
    指定された.onionドメインがTorネットワーク経由でアクセス可能かどうかを確認する関数。
    
    Args:
    url (str): 確認する.onionドメインのURL。
    
    Returns:
    bool: アクセス可能ならTrue、そうでなければFalse。
    """
    try:
        response = requests.get(url, proxies=proxies, timeout=30)
        return response.status_code == 200
    except requests.RequestException as e:
        print(f"Error accessing {url}: {e}")
        return False

def send_email(subject, body):
    """
    指定されたメールアドレスにメールを送信する関数。
    
    Args:
    subject (str): メールの件名。
    body (str): メールの本文。
    """
    from_email = "wannabeskywalker@gmail.com"
    from_password = "svmj rovs dgjf ynbq"
    to_email = "jacktomamenokineet@icloud.com"

    # メールの作成
    msg = MIMEMultipart()
    msg['From'] = from_email
    msg['To'] = to_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    # メールの送信
    try:
        server = smtplib.SMTP('smtp.gmail.com', 587)
        server.starttls()
        server.login(from_email, from_password)
        server.sendmail(from_email, to_email, msg.as_string())
        server.close()
        print("Email sent successfully")
    except Exception as e:
        print(f"Failed to send email: {e}")

def check_onion_sites():
    onion_urls_test = [
        "https://duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion/",
        "http://arcuufpr5xxbbkin4mlidt7itmr6znlppk63jbtkeguuhszmc5g7qdyd.onion/",
        "http://lockbit7z6rzyojiye437jp744d4uwtff7aq7df7gh2jvwqtv525c4yd.onion/"
    ]
    onion_urls = [
        "http://basemmnnqwxevlymli5bs36o5ynti55xojzvn246spahniugwkff2pad.onion/",
        "http://xb6q2aggycmlcrjtbjendcnnwpmmwbosqaugxsqb4nx6cmod3emy7sad.onion/"
    ]
    accessible_sites = []

    for onion_url in onion_urls:
        if is_onion_site_accessible(onion_url):
            print(f"{time.ctime()}: {onion_url} is accessible via Tor.")
            accessible_sites.append(onion_url)
        else:
            print(f"{time.ctime()}: {onion_url} is not accessible via Tor.")

    if accessible_sites:
        accessible_sites_str = "\n".join(accessible_sites)
        send_email(
            subject="Onion Site Access Alert",
            body=f"The following sites are accessible via Tor:\n{accessible_sites_str}"
        )


if __name__ == "__main__":
    check_interval = 20  # チェック間隔（秒）
    while True:
        check_onion_sites()
        time.sleep(check_interval)
