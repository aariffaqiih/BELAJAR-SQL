SELECT * FROM nasabah;
SELECT * FROM kekayaan;

1. Tampilkan nama nasabah, kota, dan total kekayaan mereka. Urutkan dari yang paling kaya ke paling miskin.
SELECT nasabah.id, nasabah.nama, nasabah.kota, SUM(kekayaan.nilai)
FROM nasabah
INNER JOIN kekayaan
ON nasabah.id = kekayaan.id
GROUP BY nasabah.id
ORDER BY kekayaan.nilai DESC;

SELECT nasabah.nama, nasabah.kota, SUM(kekayaan.nilai) AS total_kekayaan
FROM nasabah
INNER JOIN kekayaan ON nasabah.id = kekayaan.id
GROUP BY nasabah.id, nasabah.nama, nasabah.kota
ORDER BY total_kekayaan DESC;

2. Tampilkan nama dan aset milik nasabah yang bernama 'Andi'.
SELECT nasabah.nama, kekayaan.aset
FROM nasabah
INNER JOIN kekayaan
ON nasabah.id = kekayaan.id
WHERE nasabah.nama = 'Andi';

3. Tampilkan nama, kota, dan pekerjaan nasabah yang punya kekayaan lebih dari 3.000 juta.
SELECT nasabah.nama, nasabah.kota, nasabah.pekerjaan
FROM nasabah
INNER JOIN kekayaan
ON nasabah.id = kekayaan.id
WHERE kekayaan.nilai > 3000;

SELECT nasabah.nama, nasabah.kota, nasabah.pekerjaan, SUM(kekayaan.nilai) AS total_kekayaan
FROM nasabah
INNER JOIN kekayaan ON nasabah.id = kekayaan.id
GROUP BY nasabah.id, nasabah.nama, nasabah.kota, nasabah.pekerjaan
HAVING SUM(kekayaan.nilai) > 3000;

4. Tampilkan nama nasabah dan daftar aset yang mereka miliki dengan nilai masing-masing.
SELECT nasabah.nama, kekayaan.aset, kekayaan.nilai
FROM nasabah
INNER JOIN kekayaan
ON nasabah.id = kekayaan.id;

SELECT nasabah.nama, GROUP_CONCAT(kekayaan.aset) AS daftar_aset
FROM nasabah
INNER JOIN kekayaan ON nasabah.id = kekayaan.id
GROUP BY nasabah.nama;

5. Tampilkan kota dengan jumlah nasabah yang kekayaannya di atas 2.000 juta.
SELECT nasabah.kota, SUM(kekayaan.nilai) AS harta
FROM nasabah
INNER JOIN kekayaan
ON nasabah.id = kekayaan.id
GROUP BY nasabah.kota
ORDER BY harta DESC;

SELECT kota, COUNT(*) AS jumlah_nasabah_kaya
FROM (
    SELECT nasabah.id, nasabah.kota, SUM(kekayaan.nilai) AS total_kekayaan
    FROM nasabah
    INNER JOIN kekayaan ON nasabah.id = kekayaan.id
    GROUP BY nasabah.id, nasabah.kota
    HAVING SUM(kekayaan.nilai) > 2000
) AS nasabah_kaya
GROUP BY kota;

6. Tampilkan total kekayaan untuk masing-masing pekerjaan. Urutkan dari yang tertinggi ke terendah.
SELECT nasabah.pekerjaan, SUM(kekayaan.nilai) AS harta
FROM nasabah
INNER JOIN kekayaan
ON nasabah.id = kekayaan.id
GROUP BY nasabah.pekerjaan
ORDER BY harta DESC;

7. Tampilkan nama nasabah dan aset termahal yang dimilikinya.
SELECT nasabah.nama, kekayaan.nilai AS terbanyak
FROM nasabah
INNER JOIN kekayaan
ON nasabah.id = kekayaan.id;

SELECT n.nama, k.aset, k.nilai
FROM nasabah n
JOIN kekayaan k ON n.id = k.id
WHERE (k.id, k.nilai) IN (
    SELECT id, MAX(nilai)
    FROM kekayaan
    GROUP BY id
);

8. Tampilkan daftar nasabah yang tidak memiliki aset apapun.
SELECT nasabah.nama
FROM nasabah
LEFT JOIN kekayaan
ON nasabah.id = kekayaan.id
WHERE kekayaan.aset IS NULL;
