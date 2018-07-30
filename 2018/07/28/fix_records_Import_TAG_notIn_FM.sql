----------------------
-- import_TAG
----------------------
-- 211 rows in import_TAG: Import_TAG not in Import_Fundmap.TAG-Info in ChargeHDR
select r.pin, ShortDescr from import_TAG t 
					join Import_Revobj r on t.ShortDescr = r.TAGCd and r.EffStatus = 'a' and r.SeqNo = (select max(seqNo) from Import_RevObj sub where sub.TranKey = r.TranKey)
					where not exists(select TAG from import_FundMap f where f.TAG = t.ShortDescr and TaxAuthorityType <> 'SPASS' ) 
					and BegEffYear = (select max(begEffYear) from import_Tag sub where sub.ShortDescr = t.ShortDescr) and t.EffStatus = 'A'
					and exists (select 1 from Import_chargehdr c where r.TranKey = c.RevObjID) group by r.pin, shortDescr

select * from import_revobj where TAGCd = '026-311'
         

