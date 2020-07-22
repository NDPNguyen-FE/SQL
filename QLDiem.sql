create database QLDiem
use QLDiem
create table HocVien (MaHV char(10) not null,
				   HoTen varchar(50) not null,
				   QueQuan varchar(50) not null,
				   DienThoai varchar(10),
				   NgaySinh date)
create table MonHoc (MaMon char(10) not null,
						TenMon varchar(50) not null,
						SoTiet int not null,
						SoTinChi int)
create table DiemThi (MaDiem char(10) not null,
					  MaHV char(10) not null,
					  MaMon char(10) not null,
					  NgayThi date not null,
					  Diem float not null)

alter table HocVien add constraint FK_MaHV primary key (MaHV)
alter table MonHoc add constraint KF_MaMon primary key (MaMon)
alter table DiemThi add constraint FK_MaDiem primary key (MaDiem)
alter table DiemThi add constraint PK_MaDiem foreign key (MaHV) references HocVien (MaHV)
alter table DiemThi add constraint KH_MaDiem foreign key (MaMon) references MonHoc (MaMon)

alter table DiemThi add check(NgayTHi <getdate())

ALTER TABLE MonHoc
ADD DEFAULT 1 FOR SoTinChi

insert into HocVien values ('HV01','Nguyen Van A','Da Nang','0999999999','1995-06-12'),
							('HV02','Nguyen Van B','Quang Ngai','0999999998','1995-07-11'),
							('HV03','Nguyen Van C','Hue','0999999997','1995-07-08'),
							('HV04','Nguyen Thi D','Quang Nam','0999999996','1995-01-25'),
							('HV05','Nguyen Van E','Ho Chi Minh','0999999995','1995-04-29')
insert into MonHoc values ('M01','SQL2012',60,2),
						  ('M02','JS',60,3),
						  ('M03','C#',60,3),
						  ('M04','PHP',60,2),
						  ('M05','HTML',60,4) 
insert into DiemThi values ('D01','HV01','M01','2019-05-12',7),
						   ('D02','HV03','M04','2019-03-21',6),
						   ('D03','HV04','M05','2019-03-18',8),
						   ('D04','HV02','M03','2019-03-22',5),
						   ('D05','HV05','M02','2019-03-24',9)
/*cau4*/
update HocVien
set DienThoai=0123456789
where MaHV='HV01'
/*cau5*/
select *
from DiemThi join HocVien on DiemThi.MaHV=HocVien.MaHV
where HoTen='Nam'
/*cau6*/
select top 1 DiemThi.*,TenMon,SoTinChi,SoTiet
from DiemThi join MonHoc on DiemThi.MaMon=MonHoc.MaMon
where TenMon='SQL2012'
/*cau7*/
select diemthi.MaHV,mamon,tam.so as 'So Lan Thi'
from DiemThi join (select MaHV,count(mahv) as so from DiemThi group by MaHV) as tam on diemthi.MaHV=tam.MaHV
order by mahv desc

/*caau8*/
create view vw_ThongTinDiemThi
as select HocVien.MaHV,HoTen,TenMon,Diem, CASE
											WHEN Diem>=5 THEN 'Pass'
											ELSE 'Fail'
											END  as exam
from HocVien join DiemThi on HocVien.MaHV=DiemThi.MaHV
		  join MonHoc on DiemThi.MaMon=MonHoc.MaMon
select * from vw_ThongTinDiemThi

/*câu 9*/
create proc usp_DiemThi @ma_hv char(10)
as
if @ma_hv is null 
 select HocVien.*,MaMon,diem
 from HocVien join DiemThi on HocVien.MaHV=DiemThi.MaHV
 else 
 select HocVien.*,MaMon,diem
 from HocVien join DiemThi on HocVien.MaHV=DiemThi.MaHV
 where @ma_hv=diemthi.MaHV

drop proc usp_DiemThi
exec usp_DiemThi null

/*câu 10*/
create trigger Check_SoTC_MonHoc on MonHoc
for insert
as
if (select SoTinChi from inserted)=1 and (select SoTiet from inserted)>=15
	begin
	 print N'Chủ để không hợp lệ'
	 ROLLBACK TRANSACTION
	end

insert into MonHoc values ('M07','SQL2012',60,1)






