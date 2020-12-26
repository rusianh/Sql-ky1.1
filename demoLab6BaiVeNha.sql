create database demoLab7BaiVeNha
GO
use demoLab7BaiVeNha
GO
create table NHA_CUNG_CAP (
	Ma int primary key identity,
	Ten nvarchar(150) NOT NULL, 
	DiaChi nvarchar(200) NOT NULL, 
	DienThoai char(10) NOT NULL
)
;
create table MAT_HANG (
	Ma int primary key identity, 
	Ten nvarchar(100) NOT NULL, 
	DonViTinh nvarchar(5) NOT NULL, 
	QuiCach nvarchar(5) NOT NULL, 
	SoLuongTon int NOT NULL DEFAULT(1)
)
;
create table CUNG_UNG (
	MaNhaCungCap int NOT NULL, 
	MaMatHang int NOT NULL,
	PRIMARY KEY (MaNhaCungCap,MaMatHang)
)
;
create table DAT_HANG (
	So int primary key identity, 
	Ngay date NOT NULL, 
	MaNhaCungCap int NOT NULL, 
	GhiChu nvarchar(500), 
	SoMatHang int NOT NULL default(1), 
	ThanhTien int NOT NULL DEFAULT(0)
)
;
create table CHI_TIET_DAT_HANG (
	SoDatHang int NOT NULL, 
	MaMatHang int NOT NULL, 
	SoLuongDat int NOT NULL DEFAULT(1), 
	DonGiaDat int NOT NULL DEFAULT(0)
)
;
create table GIAO_HANG(
	So int primary key identity, 
	Ngay date NOT NULL, 
	SoDatHang int NOT NULL
)
;
create table CHI_TIET_GIAO_HANG(
	SoGiaoHang int NOT NULL , 
	MaMatHang int NOT NULL, 
	SoLuongGiao int NOT NULL DEFAULT(1)
)
;
GO
ALTER TABLE CUNG_UNG ADD CONSTRAINT FK_CUNGUNG_NHACUNGCAP FOREIGN KEY (MaNhaCungCap) REFERENCES NHA_CUNG_CAP(Ma);
ALTER TABLE CUNG_UNG ADD CONSTRAINT FK_CUNGUNG_MATHANG FOREIGN KEY (MaMatHang) REFERENCES MAT_HANG(Ma);

ALTER TABLE DAT_HANG ADD CONSTRAINT FK_DATHANG_NHACUNGCAP FOREIGN KEY (MaNhaCungCap) REFERENCES NHA_CUNG_CAP(Ma);

ALTER TABLE CHI_TIET_DAT_HANG ADD CONSTRAINT FK_CTDATHANG_DATHANG FOREIGN KEY (SoDatHang) REFERENCES DAT_HANG(So);
ALTER TABLE CHI_TIET_DAT_HANG ADD CONSTRAINT FK_CTDATHANG_MATHANG FOREIGN KEY (MaMatHang) REFERENCES MAT_HANG(Ma);

ALTER TABLE GIAO_HANG ADD CONSTRAINT FK_GIAOHANG_DATHANG FOREIGN KEY (SoDatHang) REFERENCES DAT_HANG(So);

ALTER TABLE CHI_TIET_GIAO_HANG ADD CONSTRAINT FK_CTGIAOHANG_GIAOHANG FOREIGN KEY (SoGiaoHang) REFERENCES GIAO_HANG(So);
ALTER TABLE CHI_TIET_GIAO_HANG ADD CONSTRAINT FK_CTGIAOHANG_MATHANG FOREIGN KEY (MaMatHang) REFERENCES MAT_HANG(Ma);

ALTER TABLE CHI_TIET_DAT_HANG ADD CONSTRAINT PK_CTDATHANG PRIMARY KEY (SoDatHang,MaMatHang);

ALTER TABLE CHI_TIET_GIAO_HANG ADD CONSTRAINT PK_CTGIAOHANG PRIMARY KEY (SoGiaoHang,MaMatHang);
GO

ALTER TABLE MAT_HANG ADD CONSTRAINT CK_MATHANG_SOLUONGTON CHECK(SoLuongTon>0);
ALTER TABLE DAT_HANG ADD CONSTRAINT CK_DATHANG_SOMATHANG CHECK(SoMatHang<=10);
ALTER TABLE MAT_HANG ADD CONSTRAINT CK_MATHANG_DONVITINH CHECK(DonViTinh IN (N'lốc', N'chai', N'thùng', N'túi', N'bao', N'bình',N'hộp', N'hũ', N'gói', N'kg'));
ALTER TABLE MAT_HANG ADD CONSTRAINT CK_MATHANG_QUYCACH CHECK(QuiCach IN ( N'chai', N'thùng',N'hộp', N'gói'));
ALTER TABLE NHA_CUNG_CAP ADD CONSTRAINT CK_NHA_CUNG_CAP_SODIENTHOAI CHECK (DienThoai like '__-%' OR DienThoai like '___-%' OR ISNUMERIC(REPLACE(DienThoai,'-',''))=1);

--2.6. Trong một lần đặt hàng, nhà cung cấp có thể giao hàng tối đa 3 lần
create trigger tg_giaohang_khongqua3lan
on GIAO_HANG
FOR INSERT
AS
BEGIN
	DECLARE @solangiao int = 0;
	SET @solangiao = (SELECT count(1) FROM GIAO_HANG where SoDatHang=(select SoDatHang from inserted));
	IF @solangiao>=3
	BEGIN
		PRINT('Khong duoc giao qua 3 lan cho cung 1 don hang. Hien da giao '+CAST(@solangiao as varchar)+' lan');
		ROLLBACK;
	END;
END;
GO
--2.7. Không được phép giao hàng trễ hơn một tuần
create trigger tg_giaohang_khongqua1tuan
ON GIAO_HANG
FOR INSERT
AS
BEGIN
	--IF(select Ngay from inserted)>(select DATEADD(day,7, ngay) from DAT_HANG where So=(select sodathang from inserted))
	IF(select count(1) from DAT_HANG a, inserted b where a.So=b.SoDatHang and b.Ngay>DATEADD(day,7,a.ngay))>0
	BEGIN
		PRINT('Khong duoc phep giao hang cham qua 7 ngay!');
		ROLLBACK;
	END;
END;
GO
--2.8. Chỉ có thể đặt các mặt hàng mà nhà cung cấp đó cung ứng
create trigger tg_CHI_TIET_DAT_HANG_CungNhaCungCap
ON CHI_TIET_DAT_HANG
FOR INSERT
AS
BEGIN
	--IF(select MaNhaCungCap FROM inserted a, CUNG_UNG b where a.MaMatHang=b.MaMatHang)<>(select distinct MaNhaCungCap FROM CHI_TIET_DAT_HANG a, CUNG_UNG b WHERE a.MaMatHang=b.MaMatHang)
	IF(select count(distinct b.MaNhaCungCap) from (select * from inserted union all select * from CHI_TIET_DAT_HANG where SoDatHang=(select SoDatHang from inserted)) a, CUNG_UNG b where a.MaMatHang=b.MaMatHang)>1
	BEGIN
		PRINT(N'Chỉ có thể đặt các mặt hàng mà nhà cung cấp đó cung ứng');
		ROLLBACK;
	END;
END;
GO