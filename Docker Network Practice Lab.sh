# 1. Mevcut container ve network temizliği
docker container rm -f $(docker container ls -aq)
docker network rm $(docker network ls -q -f type=custom)

# 2. Özel network oluştur
docker network create --driver bridge --subnet=10.10.0.0/16 --ip-range=10.10.10.0/24 --gateway=10.10.10.10 custom-bridge-net
docker network inspect custom-bridge-net

# 3. Basit web sunucu container
docker run -d --name web-frontend --network custom-bridge-net -p 8080:80 nginx:1.16

# 4. Erişim testi ve log kontrol
docker logs web-frontend

# 5. Canlı log takibi ve hata testi
docker logs -f web-frontend

# 6. Test amaçlı container
docker run -dit --name test-container ahmet/test-app sh

# 7. Network'e ekle
docker network connect custom-bridge-net test-container

# 8. Bağlantı testi (attach olduktan sonra ping yapman lazım)
docker attach test-container

# 9. Test container'larını sil
docker rm -f web-frontend test-container

# 10. Çalışma klasörüne geç (bu manuel kalıyor)
# cd ./docker-proje/app-test

# 11. Uygulama sunucusu
docker run -d --name app --network custom-bridge-net --cpus=2 -p 80:80 --env-file env.list ahmet/app1

# 12. Veritabanı container
docker run -d --name db --network custom-bridge-net --memory=1g --env-file envmysql.list ahmet/db1

# 13. Veritabanı başlatma kontrolü
docker logs db

# 14. Uygulama testi (browser'dan manuel)
# http://localhost

# 15. Temizlik
docker rm -f app db
docker network rm custom-bridge-net