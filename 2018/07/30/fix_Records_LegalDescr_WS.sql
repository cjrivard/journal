select top 10 right(ltrim(rtrim(DescrDetailType)), 1), * from import_legaldescr where DescrType = 'platted'

select descrtype from Import_LegalDescr group by DescrType

select top 10 right(ltrim(rtrim(DescrDetailType)), 1),* from Import_LegalDescr where DescrType in ('MobHomeDescr0','MobHomeDescr1','MobHomeDescr2','MobHomeDescr3','MobHomeDescr4') 
	and DescrDetailType in ('DecalNumber1','DecalNumber2','DecalNumber3','DecalNumber4',
		'HCD1','HCD2','HCD3','HCD4','HCD5','HCD6','HCD7','HCD8',
		'SerialNumber1','SerialNumber2','SerialNumber3','SerialNumber4','SerialNumber5','SerialNumber6','SerialNumber7','SerialNumber8')



select ltrim(rtrim(DescrDetailType)) from Import_LegalDescr where DescrType in ('MobHomeDescr0','MobHomeDescr1','MobHomeDescr2','MobHomeDescr3','MobHomeDescr4') group by DescrDetailType order by 1


--Violation of PRIMARY KEY constraint 'DescrHeader0'. Cannot insert duplicate key in object 'dbo.DescrHeader'. The duplicate key value is (3539870, Jul  4 1776 12:00AM).
select dbo.STShortDescr(descrtypeid),dbo.STShortDescr(descrdetailtypeid),* from conv_legaldescr where descrheaderid = 3539870

select * from Import_LegalDescr where _rowid_ = 7293396

select * from Import_LegalDescr where TranKey = 9611304
/*
drop table Import_LegalDescr

select * into import_legaldescr from [CA-Riverside-Conv-22f].dbo.import_legaldescr
*/

select cast(right(ltrim(rtrim(DescrType)),1) as int) * cast(right(LTRIM(rtrim(DescrDetailType)), 1) as INT), * 
from Import_LegalDescr where DescrType in ('MobHomeDescr0','MobHomeDescr1','MobHomeDescr2','MobHomeDescr3','MobHomeDescr4')
and right(ltrim(rtrim(DescrType)),1) <> right(LTRIM(rtrim(DescrDetailType)), 1)
and DescrDetailType in ('DecalNumber1','DecalNumber2','DecalNumber3','DecalNumber4',
		'HCD1','HCD2','HCD3','HCD4','HCD5','HCD6','HCD7','HCD8',
		'SerialNumber1','SerialNumber2','SerialNumber3','SerialNumber4','SerialNumber5','SerialNumber6','SerialNumber7','SerialNumber8')
	order by 1

select * from systype where shortDescr like 'MobHomeDescr%'



---- ERROR MESSAGE        : Violation of PRIMARY KEY constraint 'DescrHeader0'. Cannot insert duplicate key in object 'dbo.DescrHeader'. The duplicate key value is (3540015, Jul  4 1776 12:00AM).
select top 10 * from conv_legaldescr
select * from conv_legaldescr where descrheaderid = 3540015
select * from Import_LegalDescr where _rowid_ in (7294940,7294963,7295002,7295108,7295158)

update Import_LegalDescr set DescrType = 'MobHomeDescr' where DescrType in ('MobHomeDescr0','MobHomeDescr1','MobHomeDescr2','MobHomeDescr3','MobHomeDescr4')

select descrtype from Import_LegalDescr i where EXISTS(select 1 from Import_LegalDescr sub where sub.TranKey = i.trankey and sub.DescrType = 'MobHomeDescr') 
and descrtype = 'platted' group by i.DescrType

select top 10 * from Import_LegalDescr i where EXISTS(select 1 from Import_LegalDescr sub where sub.TranKey = i.trankey and sub.DescrType = 'MobHomeDescr') 
and descrtype = 'platted' 

select * from Import_LegalDescr where TranKey = 287300015
;with MHSequence as (
select 
	NewSequence = DENSE_RANK() over ( order by trankey, MHHeaderIndex),
	_rowid_ 
from Import_LegalDescr
--join conv_legaldescr c
--	on i._rowid_ = c._rowid_
where i.TranKey =287300015 
and i.DescrType in ('MobHomeDescr1', 'MobHomeDescr2'))
update i set DescrHeaderIndex = newSequence
from Import_LegalDescr i
join MHSequence mh
	on i._rowid_ = mh._rowid_

select descrHeaderIndex, count(1) from Import_LegalDescr where DescrType = 'platted' group by descrHeaderIndex
select descrHeaderIndex, count(1) from Import_LegalDescr where DescrType = 'TSDescrType' group by descrHeaderIndex

select mhHeaderIndex, count(1) from Import_LegalDescr where DescrType = 'MobHomeDescr' group by MHHeaderIndex
select top 10 * from Import_LegalDescr where MHHeaderIndex = '1e'

select * from dbo.STSiblings(6000502) where ShortDescr like 'MobHomeDescr%' -- 130002	DescrType	250055	MobHomeDescr	0
/*
SysTypeCatId SysTypeCat       SysTypeId   ShortDescr       Descr                                                            DisplayOrder
------------ ---------------- ----------- ---------------- ---------------------------------------------------------------- ------------
130002       DescrType        250055      MobHomeDescr     Mobile Home Description                                          0
130002       DescrType        6000498     MobHomeDescr0    Mobile Home Description 0                                        11
130002       DescrType        6000499     MobHomeDescr1    Mobile Home Description 1                                        12
130002       DescrType        6000502     MobHomeDescr2    Mobile Home Description 2                                        13
130002       DescrType        6000503     MobHomeDescr3    Mobile Home Description 3                                        14
130002       DescrType        6000688     MobHomeDescr4    Mobile Home Description 4                                        15
*/


update import_legaldescr set MHHeaderIndex = right(ltrim(rtrim(DescrType)), 1) + right(ltrim(rtrim(DescrDetailType)), 1) 
where DescrType in ('MobHomeDescr0','MobHomeDescr1','MobHomeDescr2','MobHomeDescr3','MobHomeDescr4') 

select MHHeaderIndex = right(ltrim(rtrim(DescrType)), 1) + case when isnumeric(right(ltrim(rtrim(DescrDetailType)), 1)) = '1' then right(ltrim(rtrim(DescrDetailType)), 1) else '0' end, * 
from Import_LegalDescr
where DescrType in ('MobHomeDescr1','MobHomeDescr1','MobHomeDescr2','MobHomeDescr3','MobHomeDescr4') 
and DescrDetailType = 'Year'

-- ERROR MESSAGE        : Violation of PRIMARY KEY constraint 'DescrHeader0'. Cannot insert duplicate key in object 'dbo.DescrHeader'. The duplicate key value is (7485272, Jul  4 1776 12:00AM).
select * from conv_legaldescr where descrheaderid = 7485272
select * from Import_LegalDescr i
join conv_legaldescr c
	on i._rowid_ = c._rowid_
where i._rowid_ in (1,3)

-- ERROR MESSAGE        : Violation of PRIMARY KEY constraint 'DescrHeader0'. Cannot insert duplicate key in object 'dbo.DescrHeader'. The duplicate key value is (2667024, Jul  4 1776 12:00AM).
select * from conv_legaldescr where descrheaderid = 2667024
select * from Import_LegalDescr i
join conv_legaldescr c
	on i._rowid_ = c._rowid_
where i._rowid_ in (7683915,196860)

--insert statement from conv_dev script
--Insert into DescrHeader
--		(Id,BegEffDate,EffStatus,TranId,RevObjId,DescrHeaderType,SequenceNumber,DisplayDescr)
	Select  
		c.DescrHeaderId as Id,
		i.BegEffDate,
		i.EffStatus,
		--@v_tranid as TranId,
		i.trankey as RevObjId,
		c.DescrTypeId as DescrHeaderType,
		c.SequenceNumber,
		c.DisplayDescr
	from Import_LegalDescr i
	join conv_legaldescr c
		on i._rowid_ = c._rowid_
	where c.DisplayDescr <> ''
	and i.SequenceNumber = (select min(SequenceNumber) from Import_LegalDescr sub where sub.TranKey = i.TranKey)
	--and i.DescrType in ()
	and i.TranKey = 8100465
	group by c.DescrHeaderId, i.BegEffDate,i.EffStatus,i.trankey,c.DescrTypeId,c.SequenceNumber,c.DisplayDescr, i.SequenceNumber

-- ERROR MESSAGE        : Violation of PRIMARY KEY constraint 'DescrHeader0'. Cannot insert duplicate key in object 'dbo.DescrHeader'. The duplicate key value is (1432830, Jul  4 1776 12:00AM).
select * from conv_legaldescr where descrheaderid = 1432830
select * from Import_LegalDescr i
join conv_legaldescr c
	on i._rowid_ = c._rowid_
where i._rowid_ in (7692778,250825)

-- ERROR MESSAGE        : Violation of PRIMARY KEY constraint 'DescrHeader0'. Cannot insert duplicate key in object 'dbo.DescrHeader'. The duplicate key value is (3901626, Jul  4 1776 12:00AM).
select * from conv_legaldescr where descrheaderid = 3901626
select cast(i.MHHeaderIndex as INT) + i.descrHeaderIndex, * from Import_LegalDescr i
join conv_legaldescr c
	on i._rowid_ = c._rowid_
where i._rowid_ in (7684683,197993)

select * from conv_platted_details where descrheaderid = 5136527

-- ERROR MESSAGE        : Violation of PRIMARY KEY constraint 'DescrHeader0'. Cannot insert duplicate key in object 'dbo.DescrHeader'. The duplicate key value is (7041528, Jul  4 1776 12:00AM).
select * from conv_legaldescr where descrheaderid = 7041528
select * from conv_platted_details where descrheaderid = 7041528

select * from Import_LegalDescr where TranKey = 563151005

--fresh run no errors
select * from Import_LegalDescr where TranKey = 563151005
select * from DescrHeader where RevObjId = 563151005

--Need to reset the data in import_legalDescr to rerun
select top 10 * from Import_LegalDescr where trankey = 9612338
select * from Import_LegalDescr_ORIG  where trankey = 9612338



update I set DescrType = o.DescrType
from Import_LegalDescr i
join Import_LegalDescr_ORIG o
	on i._rowid_ = o._rowid_
	--and i.DescrType= o.DescrType
	and i.TranKey = o.TranKey
where i.DescrType <> o.DescrType
GO

update I set DescrDetailType = o.descrDetailType
from Import_LegalDescr i
join Import_LegalDescr_ORIG o
	on i._rowid_ = o._rowid_
	--and i.DescrType= o.DescrType
	and i.TranKey = o.TranKey
where i.DescrDetailType <> o.descrDetailType
