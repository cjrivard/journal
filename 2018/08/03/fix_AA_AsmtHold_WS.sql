select top 10 * from import_event where AsmtTranStatus = 'hold' and TaxYear = 1983
select top 10 * from import_eventhold where TaxYear = 1983

select count(1) from import_event where AsmtTranStatus = 'hold'
select count(1) from import_eventhold

select * from SysTypeUsage where TableName = 'asmthold'

select * from systypecat where id = 11012



select top 10 * from asmthold

select top 10 * from AsmtTran

insert into #EventHold
	(ValchangeReason, HoldReason)
VALUES
	('Appeal','PendingSplMerge'),
	('Exemptions','ExRev'),
	('Assessor Request','Appr'),
	('Auditor Request','AsmtServices'),
	('Prior Sup','PriorSup'),
	('Sequence Error','SupSeqError'),
	('Type X','Title')

EXEC grm_altr_drop_column 'import_event', 'HoldReason'
GO

exec grm_altr_add_col 'import_event', 'HoldReason', 'varchar(16)', ' '
exec conv_DropTable_SP '#EventHold'
GO

declare @v_ReasonForHold int; exec grm_GetSysTypeCatId 'ReasonForHold', @v_ReasonForHold output
declare @v_tranid int; exec conv_p_get_TranId @v_tranid OUTPUT, 'CARIV-Issue-2068'

create table #EventHold (
ValchangeReason varchar(16),
HoldReason varchar(16)
);
insert into #EventHold
	(ValchangeReason, HoldReason)
VALUES
	('Appeal','PendingSplMerge'),
	('Exemptions','ExRev'),
	('Assessor Request','Appr'),
	('Auditor Request','AsmtServices'),
	('Prior Sup','PriorSup'),
	('Sequence Error','SupSeqError'),
	('Type X','Title')

update i set holdreason = tmp.Holdreason
from import_event i
join #EventHold tmp
	on i.ValChangeReason = tmp.ValchangeReason

insert into asmtHold
	(AsmtId,[Status],Reason,BegDate,EndDate,TranId,RevObjId,CreatedTranId)
select top 100
	asmtId,
	@v_AsmtHoldStatus_OnHold as [Status],
	coalesce(s.id, @v_ReasonForHold_Default) as Reason,
	PeriodStart as BegDate,
	PeriodEnd as EndDate,
	@v_TranId as Tranid,
	ro.id as RevobjId,
	300 as CreatedTranId
from import_event i 
join (select id, pin from revobj group by id, pin) ro
	on ro.PIN = at.PIN
join dbo.grm_FW_SysTypeByEffDate (@v_now, 'a') s
	on s.ShortDescr = i.holdreason
	and s.SysTypeCatId = @v_ReasonForHold
where asmttranstatus = @v_AsmtTranStatus_Hold