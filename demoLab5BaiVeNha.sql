create database demoLab6BaiVeNha
go
use demoLab6BaiVeNha
go

create table Product (
	ProductCode varchar(5) primary key,
	[Name] nvarchar(30) not null,
	Category nvarchar(30),
	Manufacturer nvarchar(30),
	Price Float,
	[Weight] int,
	Quantity int
)
;

INSERT INTO Product (ProductCode,[Name],Category,Manufacturer,Price,[Weight],Quantity)
values ('HDD01', N'ổ cứng 2TB',N'ổ cứng','Seagate',2000000,220,30);

INSERT INTO Product (ProductCode,[Name],Category,Manufacturer,Price,[Weight],Quantity)
values ('MON03',N'Màn hình 17"',N'Màn hình','ASUS',3500000,3320,64);

INSERT INTO Product (ProductCode,[Name],Category,Manufacturer,Price,[Weight],Quantity)
values ('KEY12',N'Bàn phím game',N'Bàn phím','Razer',120000,150,40);

INSERT INTO Product (ProductCode,[Name],Category,Manufacturer,Price,[Weight],Quantity)
values ('MOU03',N'Chuột không dây',N'Chuột','Rapoo',15000,80,55);

INSERT INTO Product (ProductCode,[Name],Category,Manufacturer,Price,[Weight],Quantity)
values ('SPE06',N'Loa 2.0',N'Loa','Samsung',1000000,1500,98);

INSERT INTO Product (ProductCode,[Name],Category,Manufacturer,Price,[Weight],Quantity)
values ('CAB01',N'Cable mạng 1.5m',N'Cable',N'LG Việt Nam',16000,100,156);

--1. Tạo thủ tục hiển thị tên của toàn bộ sản phẩm, thực thi câu lệnh
create procedure proc_all_products 
as
select * from Product;
exec proc_all_products;
--2. Tạo thủ tục hiển thị thong tin sản phẩm có khối lượng lớn hơn 1mức do người dùng nhập vào, thực thi câu lệnh với tham số 500
create procedure proc_products_weight
	@w int = 0
as
	select * from Product where Weight>=@w;
exec proc_products_weight 500;
--3. Tạo thủ tục tang giá của tất cả các sản phẩm lên một lượng % do người dùng nhập vào. Thực thi với tham số tăng 10%
create procedure proc_products_increaseprice
	@p int = 0
as
begin
	select * from Product;
	update Product set Price=Price+Price*@p/100;
	select * from Product;
end;
exec proc_products_increaseprice 10;
-- 4. Tạo thủ tục giảm số lượng của 1 sản phẩm (theo id) và số lượng cần giảm. Thực thi với việc giảm số lượng 10 đơn vị của sản phẩm có mã là CAB01
create procedure proc_giamsoluong
	@id varchar(5),
	@soluong int
AS
begin
	select * from Product;
	update Product set Quantity=Quantity-@soluong where ProductCode=@id;
	select * from Product;
end;
exec proc_giamsoluong 'CAB01',10;
-- 5. Tạo thủ tục cho phép trả về được giá trị qua tham số OUTPUT. Thủ tục đếm toàn các bản ghi có số lượng sản phẩm nhỏ hơn 30. 
--Thực thi thủ tục với một biến, ra ngoài thủ tục, in giá trị của biến đó ra.
create procedure proc_demsoluongbanghi
	@soluong int output
as
	select @soluong=count(1) from Product where Quantity>30;
declare @sl int = 0;
exec proc_demsoluongbanghi @soluong=@sl OUTPUT;
PRINT('So ban ghi so luong >30 la: '+cast(@sl as varchar));