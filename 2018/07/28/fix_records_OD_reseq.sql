

--Import_OD.DocDate out of order
SELECT  import_od.TranKey, import_od.SeqNo, import_od.DocDate     FROM Import_OD     
WHERE DocDate < (
	SELECT MAX ( Import_OD_SUB.DocDate)
	FROM Import_OD AS Import_OD_SUB
	WHERE Import_OD_SUB.TranKey = Import_OD.TranKey
	AND Import_OD_SUB.SeqNo < Import_OD.SeqNo
) --and od.trankey = 302060036

--302060036	6	2001-12-31 23:59:47.000
select * from import_od where TranKey = 302060036 order by SeqNo
--select * from import_revobj where trankey = 302060036
select * from import_lpr where trankey = 302060036

--618630056	7	2006-12-31 23:59:45.000
select * from import_od where TranKey = 618630056 order by SeqNo
--select * from import_revobj where trankey = 618630056
select * from import_lpr where trankey = 618630056

--467672002	6	2006-12-31 23:59:47.000
select * from import_od where TranKey = 467672002 order by SeqNo
--select * from import_revobj where trankey = 618630056
select * from import_lpr where trankey = 467672002

--334292017	11	2004-12-31 23:59:37.000
select * from import_od where TranKey = 334292017 order by SeqNo
--select * from import_revobj where trankey = 618630056
select * from import_lpr where trankey = 334292017

--441170004	12	2000-12-31 23:59:35.000
select * from import_od where TranKey = 441170004 order by SeqNo
--select * from import_revobj where trankey = 618630056
select * from import_lpr where trankey = 441170004

--342120035	8	2000-12-31 23:59:43.000
select * from import_od where TranKey = 342120035 order by SeqNo
--select * from import_revobj where trankey = 618630056
select * from import_lpr where trankey = 342120035

--134522004	5	2002-12-31 23:59:49.000
select * from import_od where TranKey = 342120035 order by SeqNo
--select * from import_revobj where trankey = 618630056
select * from import_lpr where trankey = 342120035

--369440023	7	2000-12-31 23:59:45.000
select * from import_od where TranKey = 369440023  and seqno > 5 order by SeqNo
select * from import_revobj where trankey = 618630056 and seqno > 5 
select * from import_lpr where trankey = 369440023 and seqno > 5 

--306910002	6	2007-12-31 23:59:47.000
select * from import_od where TranKey = 306910002 order by SeqNo
select * from import_revobj where trankey = 306910002 
select * from import_lpr where trankey = 306910002 

--431842009	6	2007-12-31 23:59:47.000
select * from import_od where TranKey = 431842009 order by SeqNo
select * from import_revobj where trankey = 431842009 
select * from import_lpr where trankey = 431842009 

--678041017	17	2000-12-31 23:59:25.000
select * from import_od where TranKey = 678041017 order by SeqNo
select * from import_revobj where trankey = 678041017 
select * from import_lpr where trankey = 678041017 

--306951001	7	2007-12-31 23:59:45.000
select * from import_od where TranKey = 306951001 order by SeqNo
select * from import_revobj where trankey = 306951001 
select * from import_lpr where trankey = 306951001 

--649800028	6	2004-12-31 23:59:47.000
select * from import_od where TranKey = 649800028 order by SeqNo
select * from import_revobj where trankey = 649800028 
select * from import_lpr where trankey = 649800028 

delete from import_revobj where trankey = 649800028 and seqno = 5
delete from import_od where trankey = 649800028 and seqno = 5
update import_od set seqno = seqno - 1 where trankey = 649800028 and SeqNo > 5
update import_revobj set seqno = seqno - 1 where trankey = 649800028 and SeqNo > 5
update import_lpr set seqno = seqno - 1 where trankey = 649800028 and SeqNo > 5

delete from import_revobj where trankey = 306951001 and seqno = 6
delete from import_od where trankey = 306951001 and seqno = 6
update import_od set seqno = seqno - 1 where trankey = 306951001 and SeqNo > 6
update import_revobj set seqno = seqno - 1 where trankey = 306951001 and SeqNo > 6
update import_lpr set seqno = seqno - 1 where trankey = 306951001 and SeqNo > 6

delete from import_revobj where trankey = 678041017 and seqno = 16
delete from import_od where trankey = 678041017 and seqno = 16
update import_od set seqno = seqno - 1 where trankey = 678041017 and SeqNo > 16
update import_revobj set seqno = seqno - 1 where trankey = 678041017 and SeqNo > 16
update import_lpr set seqno = seqno - 1 where trankey = 678041017 and SeqNo > 16

delete from import_revobj where trankey = 431842009 and seqno = 5
delete from import_od where trankey = 431842009 and seqno = 5
update import_od set seqno = seqno - 1 where trankey = 431842009 and SeqNo > 5
update import_revobj set seqno = seqno - 1 where trankey = 431842009 and SeqNo > 5
update import_lpr set seqno = seqno - 1 where trankey = 431842009 and SeqNo > 5

delete from import_revobj where trankey = 306910002 and seqno = 5
delete from import_od where trankey = 306910002 and seqno = 5
update import_od set seqno = seqno - 1 where trankey = 306910002 and SeqNo > 5
update import_revobj set seqno = seqno - 1 where trankey = 306910002 and SeqNo > 5
update import_lpr set seqno = seqno - 1 where trankey = 306910002 and SeqNo > 5

update import_od set SeqNo = 99 where TranKey = 369440023 and DocNumber = 'TRA 00007866482'
update import_od set SeqNo = 7 where TranKey = 369440023 and DocNumber = 'TRA 00007866485'
update import_od set SeqNo = 6 where TranKey = 369440023 and DocNumber = 'TRA 00007866482'

update import_od set RecordDateTime = '2001-01-01 00:00:00.000', DocDate = '2001-01-01 00:00:00.000' WHERE trankey = 342120035 and SeqNo = 8
update import_od set RecordDateTime = '2001-01-01 00:00:00.000', DocDate = '2001-01-01 00:00:00.000' WHERE trankey = 441170004 and SeqNo = 12
update import_od set RecordDateTime = '2005-01-01 00:00:00.000', DocDate = '2005-01-01 00:00:00.000' WHERE trankey = 334292017 and SeqNo = 11
update import_od set RecordDateTime = '2007-01-01 00:00:00.000', DocDate = '2007-01-01 00:00:00.000' WHERE trankey = 467672002 and SeqNo = 6
update import_od set RecordDateTime = '2007-01-01 00:00:00.000', DocDate = '2007-01-01 00:00:00.000' WHERE trankey = 618630056 and SeqNo = 7
update import_od set RecordDateTime = '2001-01-01 00:00:00.000', DocDate = '2001-01-01 00:00:00.000' WHERE trankey = 302060036 and SeqNo = 4
update import_od set RecordDateTime = '2002-01-01 00:00:00.000', DocDate = '2002-01-01 00:00:00.000' WHERE trankey = 302060036 and SeqNo = 6


update od set RecordDateTime =  cast(cast(dateadd(d,1,od.RecordDateTime) as date) as varchar) + ' 00:00:00.000' from import_od od where DocNumber like 'TRA %' and MONTH(RecordDateTime) = 12 and day(RecordDateTime) = 31 
and exists (select 1 from import_lpr lpr where od.trankey = lpr.trankey and od.SeqNo = lpr.SeqNo)
and not exists (select 1 from Import_RevObj ro where ro.TranKey = od.TranKey and ro.seQNO = od.SeqNo)

update od set docdate = cast(cast(dateadd(d,1,od.DocDate) as date) as varchar) + ' 00:00:00.000' from import_od od where DocNumber like 'TRA %' and MONTH(od.DocDate) = 12 and day(DocDate) = 31 
and exists (select 1 from import_lpr lpr where od.trankey = lpr.trankey and od.SeqNo = lpr.SeqNo)
and not exists (select 1 from Import_RevObj ro where ro.TranKey = od.TranKey and ro.seQNO = od.SeqNo)