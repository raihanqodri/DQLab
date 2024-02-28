-- Mengetahui jumlah bencana yang terjadi berdasarkan jenis bencana antara
-- Natural vs Technological
select 
	`Disaster Group`,
	count(`DisNo.`) as jumlah_bencana
from disaster_in_ind
where `Disaster Group` in ('Natural', 'Technological')
group by 1;

-- Mengidentifikasi tren jumlah bencana terbesar tiap tahun
select 
	`Year`,
	count(`DisNo.`) as jumlah_bencana
from disaster_in_ind
group by 1
order by 2 Desc;

-- Mengetahui jenis bencana yang paling sering terjadi (top 5)
select
	`Disaster Group`, 
	`Disaster Subgroup`,
	`Disaster Type`,
	count(`DisNo.`) as jumlah_bencana
from disaster_in_ind
group by 1, 2, 3
order by 4 desc 
limit 5;

-- Melihat dampak bencana terhadap jumlah kematian, terdampak, dan biaya kerusakan
select
	`Disaster Type`,
	`Disaster Subtype`,
	sum(`Total Deaths`) as jumlah_tewas,
	sum(`Total Affected`) as jumlah_terdampak,
	sum(`Total Damage, Adjusted ('000 US$)`) as total_kerusakan_usd
from disaster_in_ind
group by 1, 2
order by 5 desc;

-- Mengetahui lokasi yang paling sering terjadi bencana dan jumlah kerusakan(usd)
select 
	Location,
	count(`DisNo.`) as jumlah_bencana,
	sum(`Total Damage, Adjusted ('000 US$)`) as total_kerusakan_usd
from disaster_in_ind
group by 1
order by 3 desc;

-- Mengetahui jenis bencana dengan kerusakan terbesar
select 
	`Disaster Type`,
	MAX(`Total Damage, Adjusted ('000 US$)`) as kerugian
from disaster_in_ind
group by 1
order by 2 desc;

-- Menampilkan jumlah total kematian dan jumlah total kerusakan
-- bencana untuk setiap jenis bencana

select 
	`Disaster Type`,
	(select sum(`Total Deaths`) from disaster_in_ind where `Disaster Type` = dt.`Disaster Type`) as total_kematian,
	(select sum(`Total Damage, Adjusted ('000 US$)`) from disaster_in_ind dii where `Disaster Type` = dt.`Disaster Type`) as total_kerusakan
from 
	(select distinct `Disaster Type` from disaster_in_ind) as dt
order by 2 desc, 3;

-- Menampilkan total kematian dan total kerusakan bencana untuk setiap tahun bencana
select 
	`Year`,
	(select sum(`Total Deaths`) from disaster_in_ind where `Year` = dt.`Year`) as total_kematian,
	(select sum(`Total Damage, Adjusted ('000 US$)`) from disaster_in_ind dii where `Year` = dt.`Year`) as total_kerusakan
from
	(select distinct `Year` from disaster_in_ind) as dt
group by 1;

-- 
SELECT 
    `Year`,
    `Location`,
    SUM(`Total Deaths`) AS total_kematian,
    COUNT(*) AS total_bencana,
    SUM(`Total Damage, Adjusted ('000 US$)`) as total_kerugian
FROM 
    disaster_in_ind dii 
GROUP BY 
    1,2
order by 5 desc
limit 20;

-- Menghitung rata-rata bergerak dari total kerusakan bencana setiap tahun
select 
	`Year`,
	`Disaster Type`,
	`Total Damage, Adjusted ('000 US$)`,
	avg(`Total Damage, Adjusted ('000 US$)`) over (partition by `Year` order by `Year`) as rata_rata_kerusakan
from disaster_in_ind dii;
	

