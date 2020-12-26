CREATE DATABASE demoLab5BaiVeNha
go
use demoLab5BaiVeNha
go

CREATE TABLE Hang_Hoa (
	MaHH nchar(4) primary key NOT NULL,
	TenHH nvarchar(50) NOT NULL
)
;

create table NVL (
	MaNVL nchar(4) primary key NOT NULL,
	TenNVL nvarchar(50) NOT NULL,
	DvTinh nchar(10),
	DonGia float check(DonGia>=0)
)
;

create table Dinh_Muc(
	MaHH nchar(4) NOT NULL FOREIGN KEY REFERENCES Hang_Hoa(MaHH),
	MaNVL nchar(4) NOT NULL FOREIGN KEY REFERENCES NVL(MaNVL),
	SlDinhMuc real check(SlDinhMuc>=0),
	PRIMARY KEY (MaHH,MaNVL)
)
;
create table KHSX(
	NamThang nchar(6) NOT NULL,
	MaHH nchar(4) NOT NULL FOREIGN KEY REFERENCES Hang_Hoa(MaHH),
	SlSanXuat int check (SlSanXuat >0),
	PRIMARY KEY (NamThang,MaHH)
)
;

INSERT INTO Hang_Hoa (MaHH,TenHH)
values ('G001',N'Giầy thể thao');
INSERT INTO Hang_Hoa (MaHH,TenHH)
values ('G002',N'Giầy thời trang');
INSERT INTO Hang_Hoa (MaHH,TenHH)
values ('G003',N'Giầy trẻ em');

INSERT INTO NVL(MaNVL,TenNVL,DvTinh,DonGia)
values ('D001','Da',N'Tấm',100000);
INSERT INTO NVL(MaNVL,TenNVL,DvTinh,DonGia)
values ('D002',N'Giả da',N'Mét',70000);
INSERT INTO NVL(MaNVL,TenNVL,DvTinh,DonGia)
values ('D003',N'Nhựa','Kg',120000);
INSERT INTO NVL(MaNVL,TenNVL,DvTinh,DonGia)
values ('D004','Keo','Kg',80000);
INSERT INTO NVL(MaNVL,TenNVL,DvTinh,DonGia)
values ('D005',N'Chỉ',N'Mét',30000);

INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G001','D001',0.3);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G001','D002',0.2);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G001','D003',0.3);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G002','D001',0.2);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G002','D002',0.1);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G002','D003',0.2);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G003','D002',0.1);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G003','D003',0.1);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G003','D004',0.3);
INSERT INTO Dinh_Muc(MaHH,MaNVL,SlDinhMuc)
values ('G003','D005',0.3);

INSERT INTO KHSX(NamThang,MaHH,SlSanXuat)
values (200504,'G001',8000);
INSERT INTO KHSX(NamThang,MaHH,SlSanXuat)
values (200504,'G002',7500);
INSERT INTO KHSX(NamThang,MaHH,SlSanXuat)
values (200504,'G003',7000);
INSERT INTO KHSX(NamThang,MaHH,SlSanXuat)
values (200505,'G001',7500);
INSERT INTO KHSX(NamThang,MaHH,SlSanXuat)
values (200505,'G002',8000);


--2.1: Liệt kê thông tin định mức các nguyên vật liệu cho hàng hoá có mã G001:
select a.MaNVL AS "Mã nguyên vật liệu", TenNVL AS "Tên nguyên vật liệu", DvTinh AS "Đơn vị tính", SlDinhMuc AS "Số lượng định mức"
FROM NVL a,Dinh_Muc b WHERE a.MaNVL=b.MaNVL and b.MaHH='G001';
--2.2: Thống kế theo mã nguyên vật liệu.
select a.MaNVL AS "Mã NVL", TenNVL AS "Tên NVL", COUNT(b.MaHH) AS "Tống số hàng hoá" FROM NVL a,Dinh_Muc b where a.MaNVL=b.MaNVL GROUP BY a.MaNVL,a.TenNVL;
--2.3: Liệt kê số lượng dự toán của các nguyên vật liệu cần sử dụng cho hàng hoá có mã G001 theo kế hoạch sản xuất trong tháng 4 năm 2005.
select a.MaNVL AS "Mã NVL", TenNVL AS "Tên NVL", DvTinh AS "Đơn vị tính", b.SlDinhMuc*d.SlSanXuat AS "Số lượng dự toán"
FROM NVL a,Dinh_Muc b,Hang_Hoa c,KHSX d WHERE 
a.MaNVL=b.MaNVL 
and b.MaHH=c.MaHH
and c.MaHH=d.MaHH
and b.MaHH='G001' and d.NamThang=200504;
-- 2.4 Tương tự câu c, thêm cột thành tiền dự toán.
select a.MaNVL AS "Mã NVL", TenNVL AS "Tên NVL", DvTinh AS "Đơn vị tính", b.SlDinhMuc*d.SlSanXuat AS "Số lượng dự toán",b.SlDinhMuc*d.SlSanXuat*a.DonGia AS "Thành tiền dự toán"
FROM NVL a,Dinh_Muc b,Hang_Hoa c,KHSX d WHERE 
a.MaNVL=b.MaNVL 
and b.MaHH=c.MaHH
and c.MaHH=d.MaHH
and b.MaHH='G001' and d.NamThang=200504;
-- 3.1.Liệt kê số lượng sản xuất của các hàng hoá có mã G001 theo kế hoạch sản xuất trong tháng 4 năm 2005.
create view VW_SoLuongSanXuat31 AS
select a.MaNVL AS "Mã NVL", TenNVL AS "Tên NVL", d.SlSanXuat AS "Số lượng sản xuất"
FROM NVL a,Dinh_Muc b,Hang_Hoa c,KHSX d WHERE 
a.MaNVL=b.MaNVL 
and b.MaHH=c.MaHH
and c.MaHH=d.MaHH
and b.MaHH='G001' and d.NamThang=200504;
-- test
select * from VW_SoLuongSanXuat31;
--3.2.Liệt kê các hàng hoá khác nhau đã được sản xuất trong năm 2005
create view VW_HangHoa2005_32 AS
select distinct a.MaHH AS "Ma HH", a.TenHH as "Tên hàng hoá" FROM Hang_Hoa a, KHSX b where a.MaHH=b.MaHH and b.SlSanXuat>0 and NamThang>=200500 and NamTHang<200600;
-- test 
select * from VW_HangHoa2005_32;
-- 3.3.Liệt kê các hàng hoá chỉ được sản xuất từ những NVL có đơn giá từ 80 000 trở lên
create view VW_HangHoaNVL80k33 AS
select a.MaHH AS "Ma HH", a.TenHH AS "Tên hàng hoá", c.TenNVL AS "Tên NVL", c.DonGia AS "Đơn giá"
FROM Hang_Hoa as a, Dinh_Muc as b, NVL as c
WHERE a.MaHH=b.MaHH and b.MaNVL=c.MaNVL and DonGia>=80000;
-- test
select * from VW_HangHoaNVL80k33;
-- 3.4 Liệt kê các hàng hoá được sản xuất từ những NVL có số lượng định mức là 0,3
create view VW_HangHoaSlDinhMuc03k34 AS
select a.MaHH AS "Ma HH", a.TenHH AS "Tên hàng hoá", c.TenNVL AS "Tên NVL", b.SlDinhMuc AS "sldinhmuc"
FROM Hang_Hoa as a, Dinh_Muc as b, NVL as c
WHERE a.MaHH=b.MaHH and b.MaNVL=c.MaNVL and b.SlDinhMuc=0.3;
-- test 
select * from VW_HangHoaSlDinhMuc03k34;
-- 3.5.Liệt kê các hàng hoá có tên bắt đầu bằng chữ “Giày”, các chữ sau đó là ký tự bất kỳ
create view vw_Giay35 AS
select * from Hang_Hoa where TenHH like N'Giầy%';
-- test
select * from vw_Giay35;
-- 3.6. Liệt kê các tên hàng hoá có chứa dấu gạch dưới (_)
-- select * from Hang_Hoa where TenHH like N'%_%'; -- Sai vi dau _ thay the cho 1 ky tu bat ky, khong phai dau _ khi su dung like
SELECT CHARINDEX('t', 'Customer') AS MatchPosition; 
select a.*,CHARINDEX('_',TenHH) from Hang_Hoa as a; 
create view vw_hanghoachuagachchan36 as
select a.* from Hang_Hoa as a where CHARINDEX('_',TenHH)>0; 
-- test 
insert into Hang_Hoa(MaHH,TenHH) VALUES ('Test','Test_Du_Lieu');
select * from vw_hanghoachuagachchan36;
-- 3.7.Liệt kê các hàng hoá chưa từng có kế hoạch sản xuất
select * from Hang_Hoa where MaHH not in (select MaHH FROM KHSX);
create view vw_hanghoachuacokehoach37 as
select * from Hang_Hoa as a where not exists(select 1 from KHSX b where a.MaHH=b.MaHH);
-- test
select * from vw_hanghoachuacokehoach37;
-- 4.1. Thêm vào bảng hang_hoa cột ghi_chu, kiểu dữ liệu varchar(50)
ALTER TABLE Hang_HOA ADD Ghi_Chu varchar(50);
-- 4.2 Tạo 1 bảng sao của bảng hang_hoa có tên là hang_hoa_backup (lệnh Select…into)
select * into hang_hoa_backup from hang_hoa;
-- test
select * from hang_hoa;
select * from hang_hoa_backup;