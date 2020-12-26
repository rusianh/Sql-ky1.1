﻿create database demoLab9BaiVeNha
Go
use demoLab9BaiVeNha
Go

create table Khoa (
	ma char(4) primary key not null ,
	tenKhoa nvarchar(50) ,
	namThanhLap int  
)
;

create table KhoaHoc (
	ma int primary key identity not null ,
	namBatDau int ,
	namKetThuc int
)
;

create table SinhVien (
	ma char(15) primary key not null ,
	hoTen nvarchar(50) ,
	namSinh int ,
	danToc nvarchar(50) ,
	maLop int
)
;

create table ChuongTrinh (
	ma char(2) primary key not null ,
	tenChuongTrinh nvarchar(50)
)
;

create table MonHoc (
	ma int primary key identity not null ,
	tenMonHoc nvarchar(50) ,
	khoa nvarchar(50)
)
;

create table KetQua (
	maSinhVien char(15) not null ,
	maMonHoc int identity not null ,
	lanThi int ,
	diem decimal(2,1) ,
	PRIMARY KEY (maSinhVien,maMonHoc)
)
;

create table GiangKhoa (
	maChuongTrinh char(2) not null ,
	maKhoa char(4) not null ,
	maMonHoc int not null ,
	namHoc int ,
	hocKy char(3) ,
	soTietLyThuyet int, 
	soTietThucHanh int ,
	soTinChi int
	PRIMARY KEY (maChuongTrinh,maKhoa,maMonHoc)
)
;

create table Lop(
	ma int primary key identity not null ,
	maKhoaHoc int not null ,maKhoa char(4) not null ,
	maChuongTrinh char(2) not null ,
	soThuTu int
)
;
GO

ALTER TABLE KetQua ADD CONSTRAINT FK_KetQua_SinhVien FOREIGN KEY (maSinhVien) REFERENCES SinhVien(ma);
ALTER TABLE KetQua ADD CONSTRAINT FK_KetQua_MonHoc FOREIGN KEY (maMonHoc) REFERENCES MonHoc(ma);

ALTER TABLE GiangKhoa ADD CONSTRAINT FK_GiangKhoa_ChuongTrinh FOREIGN KEY (maChuongTrinh) REFERENCES ChuongTrinh(ma);
ALTER TABLE GiangKhoa ADD CONSTRAINT FK_GiangKhoa_Khoa FOREIGN KEY (maKhoa) REFERENCES Khoa(ma);
ALTER TABLE GiangKhoa ADD CONSTRAINT FK_GiangKhoa_MonHoc FOREIGN KEY (maMonHoc) REFERENCES MonHoc(ma);

ALTER TABLE Lop ADD CONSTRAINT FK_Lop_KhoaHoc FOREIGN KEY (maKhoaHoc) REFERENCES KhoaHoc(ma);
ALTER TABLE Lop ADD CONSTRAINT FK_Lop_Khoa FOREIGN KEY (maKhoa) REFERENCES Khoa(ma);
ALTER TABLE Lop ADD CONSTRAINT FK_Lop_ChuongTrinh FOREIGN KEY (maChuongTrinh) REFERENCES ChuongTrinh(ma);

ALTER TABLE ChuongTrinh ADD CONSTRAINT CK_ChuongTrinh_ma CHECK(ma IN ('CQ','CD','TC'));

ALTER TABLE GiangKhoa ADD CONSTRAINT CK_GiangKhoa_namHoc CHECK(namHoc IN (1,2,3,4));
ALTER TABLE GiangKhoa ADD CONSTRAINT CK_GiangKhoa_hocKy CHECK(hocKy IN ('HK1','HK2'));
ALTER TABLE GiangKhoa ADD CONSTRAINT CK_GiangKhoa_soTietLyThuyet CHECK(soTietLyThuyet<=120);
ALTER TABLE GiangKhoa ADD CONSTRAINT CK_GiangKhoa_soTietThucHanh CHECK(soTietThucHanh<=120);
ALTER TABLE GiangKhoa ADD CONSTRAINT CK_GiangKhoa_soTinChi CHECK(soTinChi<=6);

ALTER TABLE KetQua ADD CONSTRAINT CK_KetQua_diem CHECK(diem<=10);
-- làm tròn 0.5

ALTER TABLE Khoa ADD CONSTRAINT CK_Khoa_namThanhLap CHECK(namThanhLap>1990);

ALTER TABLE KhoaHoc ADD CONSTRAINT CK_KhoaHoc_namBatDau CHECK(namBatDau>1990);
ALTER TABLE KhoaHoc ADD CONSTRAINT CK_KhoaHoc_namKetThuc CHECK(namKetThuc>=KhoaHoc.namBatDau);

ALTER TABLE GiangKhoa ADD CONSTRAINT CK_GiangKhoa_soTietLyThuyet CHECK(soTietLyThuyet<=GiangKhoa.soTietThucHanh);

ALTER TABLE SinhVien ADD CONSTRAINT CK_SinhVien_namSinh CHECK(YEAR(getdate())-namSinh >=18);

ALTER TABLE GiangKhoa ADD CONSTRAINT CK_KhoaHoc_soTietLyThuyet CHECK(soTietLyThuyet<=GiangKhoa.soTietThucHanh);

ALTER TABLE KhoaHoc ADD CONSTRAINT CK_KhoaHoc_namBatDau CHECK(right(namBatDau,2)=KhoaHoc.ma);

--3.14. Mã sinh viên được cấu thành bởi khóa học, chương trình mà sinh viên đó đang
-- theo học kết hợp với số thứ tự (đánh số thứ tự theo cùng khóa học, cùng chương
-- trình) của sinh viên đó.
--MSSV có định dạng MãKhóaHọc-MãChươngTrình-MãKhoa- STT.
--Ví dụ : 00-CT1-CNTT-123.
GO
create trigger tg_masinhvien 
on SinhVien
INSTEAD OF insert
as
begin
	declare @masv as varchar = '';
	declare @sttsv as int = 0;
	select @masv=a.maKhoaHoc+'-'+a.maChuongTrinh+'-'+a.MaKhoa FROM Lop a, inserted b where b.maLop=a.Ma;
	--select count(1)+1 from Lop a, inserted b where a.Ma=b.MaLop GROUP BY a.MaKhoaHoc,a.MaChuongTrinh;
	WHILE(1=1)
	BEGIN
		set @sttsv = @sttsv+1;
		IF(select count(1) from SinhVien where ma=@masv+'-'+RIGHT('00'+CAST(@sttsv as varchar),3))=0
		BEGIN
			set @masv=@masv+'-'+RIGHT('00'+CAST(@sttsv as varchar),3);
			--select inserted.ma=@masv from inserted;
			--update inserted set ma=@masv;
			insert into SinhVien select @masv,hoten,namsinh,dantoc,malop from inserted;
			break;
		END;
	END;
end;
GO
