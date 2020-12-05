---Sistemde kayitli musterilerin adres bilgileri---LEFT,INNER---

SELECT M.*, u.ulke,s.sehir,i.ilce,smt.semt,a.postakod,a.acik_adres,a.adres_durum FROM MUSTERILER M
LEFT JOIN ADRESLER A ON m.musteri_id= a.adresmusteri_id
INNER JOIN ULKELER U ON a.adresulke_id=u.ulke_id
INNER JOIN SEHIRLER S ON a.adressehir_id=s.sehir_id
INNER JOIN ILCELER I ON a.adresilce_id=i.ilce_id
INNER JOIN SEMTLER SMT ON a.adressemt_id=smt.semt_id
ORDER BY m.musteri_id


---Sistemde kayitli araclara ait kategori,marka ve durum bilgileri---INNER---

SELECT a.arac_id,a.plakano,a.renk_,a.gunluk_ucret,k.kategorikod,m.marka,m.model,d.durum FROM ARACLAR A 
INNER JOIN arac_kategoriler K ON a.arac_kategori_id=k.kategori_id
INNER JOIN arac_markalar M ON a.arac_marka_id =m.marka_id
INNER JOIN arac_durumlar D ON a.arac_durum_id =d.durum_id

----Musterilerin arac kiralama islemine iliskin bilgiler---INNER---

SELECT kb.kiralama_id,m.ad,m.soyad,am.marka,am.model,s.sube_ad,kb.kiralama_tarihi,kb.teslim_edilecek_tarih,kb.arac_gunluk_ucret,
kb.kiralama_tutar,kb.kiralama_sozlesme FROM kiralama_bilgileri KB
INNER JOIN MUSTERILER M ON kb.kiralama_musteri_id=m.musteri_id
INNER JOIN ARACLAR A ON kb.kiralama_arac_id=a.arac_id
INNER JOIN ARAC_MARKALAR AM ON a.arac_marka_id=am.marka_id  
INNER JOIN SUBELER S ON kb.kiralama_sube_id=s.sube_id


---Musterilerin arac kiralama islemi detay bilgileri---INNER---

SELECT m.ad,m.soyad,kb.kiralama_sube_id ,kd.teslim_edilen_sube_id, kb.kiralama_tarihi,kd.sozlesme_teslim_tarihi,
kd.gercek_teslim_tarihi,kd.gecikme_suresi
FROM KIRALAMA_DETAYLAR KD
INNER JOIN kiralama_bilgileri KB ON kd.detay_kiralama_id=kb.kiralama_id
INNER JOIN MUSTERILER M ON kb.kiralama_musteri_id=m.musteri_id
INNER JOIN SUBELER S ON kb.kiralama_sube_id=s.sube_id
INNER JOIN SUBELER S ON kd.teslim_edilen_sube_id=s.sube_id


---Her kategori,her marka ve her aractan data uretme---CROSS JOIN---
SELECT k.kategori,m.marka,m.model FROM arac_kategoriler k CROSS JOIN arac_markalar m

-------------------------------------------------------------------------------

---UNION---

SELECT a.postakod,a.acik_adres FROM adresler a

UNION 

SELECT s.postakod,s.acik_adres FROM subeler S


---UNION ALL---

SELECT a.postakod,a.acik_adres FROM adresler a

UNION ALL

SELECT s.postakod,s.acik_adres FROM subeler S



---UNION---Kiralanabilir araclar ve kiralanamaz araclar---

SELECT a.arac_id,a.plakano,a.renk_,a.gunluk_ucret,k.kategorikod,m.marka,m.model,d.durum FROM ARACLAR A 
INNER JOIN arac_kategoriler K ON a.arac_kategori_id=k.kategori_id
INNER JOIN arac_markalar M ON a.arac_marka_id =m.marka_id
INNER JOIN arac_durumlar D ON a.arac_durum_id =d.durum_id

WHERE d.durum = 'Kiralanabilir'

UNION

SELECT a.arac_id,a.plakano,a.renk_,a.gunluk_ucret,k.kategorikod,m.marka,m.model,d.durum FROM ARACLAR A 
INNER JOIN arac_kategoriler K ON a.arac_kategori_id=k.kategori_id
INNER JOIN arac_markalar M ON a.arac_marka_id =m.marka_id
INNER JOIN arac_durumlar D ON a.arac_durum_id =d.durum_id

WHERE d.durum = 'Kiralanamaz'




---MINUS---Musterilerin sistemde kayitli guncel olmayan adresleri---


SELECT m.musteri_id,a.acik_adres FROM MUSTERILER M
INNER JOIN ADRESLER A ON m.musteri_id= a.adresmusteri_id
INNER JOIN ULKELER U ON a.adresulke_id=u.ulke_id
INNER JOIN SEHIRLER S ON a.adressehir_id=s.sehir_id
INNER JOIN ILCELER I ON a.adresilce_id=i.ilce_id
INNER JOIN SEMTLER SMT ON a.adressemt_id=smt.semt_id
WHERE a.adres_durum = 'Kullanilmiyor'

MINUS

SELECT m.musteri_id,a.acik_adres FROM MUSTERILER M
INNER JOIN ADRESLER A ON m.musteri_id= a.adresmusteri_id
INNER JOIN ULKELER U ON a.adresulke_id=u.ulke_id
INNER JOIN SEHIRLER S ON a.adressehir_id=s.sehir_id
INNER JOIN ILCELER I ON a.adresilce_id=i.ilce_id
INNER JOIN SEMTLER SMT ON a.adressemt_id=smt.semt_id
WHERE a.adres_durum = 'Birincil'




---INTERSECT---Araci zamaninda teslim ede musterilerin ad soyad bilgileri---

SELECT m.ad, M.soyad,kb.teslim_edilecek_tarih FROM kiralama_bilgileri KB
INNER JOIN musteriler M ON m.musteri_id= kb.kiralama_musteri_id

INTERSECT  

SELECT  m.ad, M.soyad,KD.gercek_teslim_tarihi FROM kiralama_detaylar KD
INNER JOIN kiralama_bilgileri KB ON kd.detay_kiralama_id=kb.kiralama_id
INNER JOIN musteriler M ON m.musteri_id= kb.kiralama_musteri_id


-----------------------------------------------------------------------------------------------------

--CONCAT Musterilerin ad ve soyadlarini birlikte getir---
 SELECT CONCAT (AD,SOYAD) FROM MUSTERILER;  

--LENGTH Musterilerden ehliyet numarasi 6 karaktere esit olmayanlari getir--
SELECT* FROM MUSTERILER WHERE LENGTH(EHLIYET_NO) <> 6;

--SUBSTR Marka adi T ile baslayan markalari getir--
SELECT* FROM ARAC_MARKALAR WHERE SUBSTR(MARKA,1,1) = 'T';

--INSTR sube adinda 'ABC' gecen subelerin sayisi--
select COUNT(*) from SUBELER where instr(sube_ad,'ABC') <>0;

--TRIM ABC ile baslayan sube isimleri artik bc ile baslasin--
select trim(leading 'A' from sube_ad) yeni_ad from SUBELER;


--Musterilerin ve adres bilgilerinin INITCAP,UPPER ve LOWER fonksiyonlari ile duzenlenmesi--

SELECT INITCAP(M.ad),UPPER(m.soyad), INITCAP(u.ulke),s.sehir,i.ilce,smt.semt,a.acik_adres,UPPER(a.adres_durum) FROM MUSTERILER M
INNER JOIN ADRESLER A ON m.musteri_id= a.adresmusteri_id
INNER JOIN ULKELER U ON a.adresulke_id=u.ulke_id
INNER JOIN SEHIRLER S ON a.adressehir_id=s.sehir_id
INNER JOIN ILCELER I ON a.adresilce_id=i.ilce_id
INNER JOIN SEMTLER SMT ON a.adressemt_id=smt.semt_id
ORDER BY m.musteri_id

--TO CHAR 8. ayda doðan musterileri getir---
SELECT * FROM MUSTERILER where to_char(Dogum_Tarih, 'MM') = '08';

--Arac Teslim tarihi carsamba gunune denk gelen kiralama bilgileri--
SELECT * FROM KIRALAMA_BILGILERI where TO_CHAR(Teslim_Edilecek_Tarih, 'Day') like 'carsamba%';

--sube Adlarindaki ABC ifadesini EFG olarak deðistir--
SELECT REPLACE(SUBE_AD,'ABC','EFG') FROM SUBELER;