------------------------------------------------------------------------
-- Levy (rpt_Levy_imp_err.sql) run on 07/27/18
------------------------------------------------------------------------
 
------------------------------------------
-- CRITICAL
------------------------------------------
 
----------------------
-- Import_Apportionment
----------------------
-- 1 rows in Import_Apportionment: UnitaryDSRate not summing to 1.00
select Taxyear,SUM(UnitaryDSRate) sumUnitaryDSRate from Import_Apportionment where UnitaryDSRate <> 0 group by TaxYear having sum(UnitaryDSRate) <> 1.00
 
-- 1 rows in Import_Apportionment: UnitaryQualifiedRate not summing to 1.00
select Taxyear,SUM(UnitaryQualifiedRate) sumUnitaryQualifiedRate from Import_Apportionment where UnitaryQualifiedRate <> 0 group by TaxYear having sum(UnitaryQualifiedRate) <> 1.00
 
-- 1 rows in Import_Apportionment: UnitaryRate not summing to 1.00
select Taxyear,SUM(UnitaryRate) sumUnitaryRate from Import_Apportionment where UnitaryRate <> 0 group by TaxYear having sum(UnitaryRate) <> 1.00
 
-- 1 rows in Import_Apportionment: UnitaryRRRate not summing to 1.00
select Taxyear,SUM(UnitaryRRRate) sumUnitaryRRRate from Import_Apportionment where UnitaryRRRate <> 0 group by TaxYear having sum(UnitaryRRRate) <> 1.00
 
----------------------
-- import_fundmap
----------------------
-- 1 rows in import_fundmap: Checking for Duplicate TAF rows(TaxAuthority/Fund) in TAG
select TAG, TaxYear, AuthorityCode, FundCode from import_FundMap group by TAG, TaxYear, AuthorityCode, FundCode having COUNT(1) > 1
 
-- 97 rows in import_fundmap: Checking for Possible FundCode duplication
select FundCode from (select FundCode, Fundname from import_FundMap where TaxAuthorityType = 'TAG' group by  FundCode, Fundname having COUNT(*) > 1) tmp group by FundCode having COUNT(1) > 1
 
-- 72495 rows in import_fundmap: DEBT FundType funds with invalid Debt FundType tax rates
select * from import_FundMap where fundtype = 'DEBT' and TaxRate not between 0.0000000001 and 0.9999999999
 
-- 47 rows in import_fundmap: Funds with < 1% Taxrate not marked Debt Service fundtype
select * from import_FundMap where TaxRate between 0.0000000001 and 0.9999999999 and fundtype <> 'DEBT'
 
-- 77 rows in import_fundmap: Funds with 1% TAXRates not marked AdValorum FundType
select * from import_FundMap where TaxRate = 1.000000000 and fundtype <> 'ADVAL1PCT'
 
-- 1 rows in import_fundmap: Import_FundMap for has both Teeter and Non-Teeter for some Fund Codes
select Fundcode from (select FundCode, FundSubCat from import_FundMap group by FundCode, FundSubCat) a group by FundCode having count(1) > 1
 
-- 4 rows in import_fundmap: Possible AuthorityCode duplication
select AuthorityCode, TaxAuthorityName from import_fundmap where authoritycode in (select AuthorityCode from (select AuthorityCode, TaxAuthorityName from import_FundMap where TaxAuthorityType <> 'TIF' group by  AuthorityCode, TaxAuthorityName having COUNT(*) > 1) tmp group by AuthorityCode having COUNT(*) > 1) group by AuthorityCode, TaxAuthorityName order by 2
 
----------------------
-- Import_PYValue
----------------------
-- 1 rows in Import_PYValue: Invalid TAF in Import_PYValue
SELECT 'Invalid TAF' msg, ValueTypeDescr, count(1) cnt 
			FROM Import_PYValue i
						JOIN ValueType v ON v.ShortDescr = i.ValueTypeDescr AND v.AttributeType1 = 470410
					WHERE not exists (	SELECT 1 
											FROM import_FundMap fm 
											WHERE i.FundCode = fm.FundCode 
												AND i.AuthorityCode = fm.AuthorityCode)
					GROUP BY i.ValueTypeDescr
		
 
-- 2 rows in Import_PYValue: Invalid TAG for ATTRIBUTE1 in Import_PYValue
select 'invalid TAG', ValueTypeDescr, count(1) from Import_PYValue i join ValueType v on v.ShortDescr = i.ValueTypeDescr and v.AttributeType1 = 470402
					where not exists (select 1 from Import_TAG t where t.ShortDescr = i.Attribute1) group by i.ValueTypeDescr
 
----------------------
-- import_TAG
----------------------
-- 211 rows in import_TAG: Import_TAG not in Import_Fundmap.TAG-Info in ChargeHDR
select ShortDescr from import_TAG t 
					join Import_Revobj r on t.ShortDescr = r.TAGCd
					where not exists(select TAG from import_FundMap f where f.TAG = t.ShortDescr and TaxAuthorityType <> 'SPASS' ) 
					and BegEffYear = (select max(begEffYear) from import_Tag sub where sub.ShortDescr = t.ShortDescr) and t.EffStatus = 'A'
					and exists (select 1 from Import_chargehdr c where r.TranKey = c.RevObjID) group by shortDescr
 
-- 5 rows in import_TAG: import_TAG.TAG not in Import_Fundmap
select ShortDescr from import_TAG t where not exists(select TAG from import_FundMap f where f.TAG = t.ShortDescr and TaxAuthorityType <> 'SPASS') and BegEffYear = (select max(begEffYear) from import_Tag sub where sub.ShortDescr = t.ShortDescr) and t.EffStatus = 'A'
 
------------------------------------------
-- HIGH
------------------------------------------
 
----------------------
-- Import_FundMap
----------------------
-- 1 rows in Import_FundMap: Checking for Duplicate TAF rows(TaxAuthority/Fund) in TAG
select TAG, TaxYear, AuthorityCode, FundCode from import_FundMap group by TAG, TaxYear, AuthorityCode, FundCode having COUNT(1) > 1
 
-- 97 rows in Import_FundMap: Checking for Possible FundCode duplication
select FundCode from (select FundCode, Fundname from import_FundMap where TaxAuthorityType = 'TAG' group by  FundCode, Fundname having COUNT(*) > 1) tmp group by FundCode having COUNT(1) > 1
 
-- 72495 rows in Import_FundMap: DEBT FundType funds with invalid Debt FundType tax rates
select * from import_FundMap where fundtype = 'DEBT' and TaxRate not between 0.0000000001 and 0.9999999999
 
-- 47 rows in Import_FundMap: Funds with < 1% Taxrate not marked Debt Service fundtype
select * from import_FundMap where TaxRate between 0.0000000001 and 0.9999999999 and fundtype <> 'DEBT'
 
-- 77 rows in Import_FundMap: Funds with 1% TAXRates not marked AdValorum FundType
select * from import_FundMap where TaxRate = 1.000000000 and fundtype <> 'ADVAL1PCT'
 
-- 1 rows in Import_FundMap: Import_FundMap for has both Teeter and Non-Teeter for some Fund Codes
select Fundcode from (select FundCode, FundSubCat from import_FundMap group by FundCode, FundSubCat) a group by FundCode having count(1) > 1
 
-- 4 rows in Import_FundMap: Possible AuthorityCode duplication
select AuthorityCode, TaxAuthorityName from import_fundmap where authoritycode in (select AuthorityCode from (select AuthorityCode, TaxAuthorityName from import_FundMap where TaxAuthorityType <> 'TIF' group by  AuthorityCode, TaxAuthorityName having COUNT(*) > 1) tmp group by AuthorityCode having COUNT(*) > 1) group by AuthorityCode, TaxAuthorityName order by 2
 
------------------------------------------
-- MEDIUM
------------------------------------------
 
----------------------
-- import_TAG
----------------------
-- 211 rows in import_TAG: Import_TAG not in Import_Fundmap.TAG-Info in ChargeHDR
select ShortDescr from import_TAG t 
					join Import_Revobj r on t.ShortDescr = r.TAGCd
					where not exists(select TAG from import_FundMap f where f.TAG = t.ShortDescr and TaxAuthorityType <> 'SPASS' ) 
					and BegEffYear = (select max(begEffYear) from import_Tag sub where sub.ShortDescr = t.ShortDescr) and t.EffStatus = 'A'
					and exists (select 1 from Import_chargehdr c where r.TranKey = c.RevObjID) group by shortDescr
 
-- 5 rows in import_TAG: import_TAG.TAG not in Import_Fundmap
select ShortDescr from import_TAG t where not exists(select TAG from import_FundMap f where f.TAG = t.ShortDescr and TaxAuthorityType <> 'SPASS') and BegEffYear = (select max(begEffYear) from import_Tag sub where sub.ShortDescr = t.ShortDescr) and t.EffStatus = 'A'
 
------------------------------------------
-- LOW
------------------------------------------
 
----------------------
-- import_fundmap
----------------------
-- 1 rows in import_fundmap: Checking for Duplicate TAF rows(TaxAuthority/Fund) in TAG
select TAG, TaxYear, AuthorityCode, FundCode from import_FundMap group by TAG, TaxYear, AuthorityCode, FundCode having COUNT(1) > 1
 
-- 97 rows in import_fundmap: Checking for Possible FundCode duplication
select FundCode from (select FundCode, Fundname from import_FundMap where TaxAuthorityType = 'TAG' group by  FundCode, Fundname having COUNT(*) > 1) tmp group by FundCode having COUNT(1) > 1
 
-- 72495 rows in import_fundmap: DEBT FundType funds with invalid Debt FundType tax rates
select * from import_FundMap where fundtype = 'DEBT' and TaxRate not between 0.0000000001 and 0.9999999999
 
-- 47 rows in import_fundmap: Funds with < 1% Taxrate not marked Debt Service fundtype
select * from import_FundMap where TaxRate between 0.0000000001 and 0.9999999999 and fundtype <> 'DEBT'
 
-- 77 rows in import_fundmap: Funds with 1% TAXRates not marked AdValorum FundType
select * from import_FundMap where TaxRate = 1.000000000 and fundtype <> 'ADVAL1PCT'
 
-- 1 rows in import_fundmap: Import_FundMap for has both Teeter and Non-Teeter for some Fund Codes
select Fundcode from (select FundCode, FundSubCat from import_FundMap group by FundCode, FundSubCat) a group by FundCode having count(1) > 1
 
-- 4 rows in import_fundmap: Possible AuthorityCode duplication
select AuthorityCode, TaxAuthorityName from import_fundmap where authoritycode in (select AuthorityCode from (select AuthorityCode, TaxAuthorityName from import_FundMap where TaxAuthorityType <> 'TIF' group by  AuthorityCode, TaxAuthorityName having COUNT(*) > 1) tmp group by AuthorityCode having COUNT(*) > 1) group by AuthorityCode, TaxAuthorityName order by 2
 
------------------------------------------------------------------------
-- AA (rpt_AAimp_err_event.sql) run on 07/27/18
------------------------------------------------------------------------
 
------------------------------------------
-- CRITICAL
------------------------------------------
 
----------------------
-- Import_EventBVS
----------------------
-- 33 rows in Import_EventBVS: BldNumber = 0 and BuildingValue <> 0
SELECT AsmtId, RevObjId, BldNumber, BuildingValue 	From Import_EventBVS
			Where BldNumber = 0 and BuildingValue <> 0
		
 
-- 2 rows in Import_EventBVS: Dupe Feature Numbers on the same AsmtId
select AsmtId, RevObjId, TaxYear, FeatureNbr  	FROM Import_EventBVS  	WHERE FeatureValue <> 0 		AND FeatureNbr <> 0 	GROUP BY AsmtId, RevObjId, TaxYear, FeatureNbr	HAVING COUNT(1) > 1
 
-- 1 rows in Import_EventBVS: FeatureNbr = 0 and FeatureValue <> 0
SELECT AsmtId, RevObjId, FeatureNbr, FeatureValue 	From Import_EventBVS
			Where FeatureNbr = 0 and FeatureValue <> 0
		
 
-- 11 rows in Import_EventBVS: LandLineNumber = 0 and LandValue <> 0
SELECT AsmtId, RevObjId, LandLineNumber, LandValue 	From Import_EventBVS
			Where LandLineNumber = 0 and landvalue <> 0
		
 
----------------------
-- Import_EventValue
----------------------
-- 312025 rows in Import_EventValue: No BaseYear4Event Valuetype in Import_EventValue for BVS
select bvs.* from Import_eventBVS bvs where not EXISTS
					(select 1 from Import_EventValue iev 
					where bvs.AsmtId = iev.AsmtId 
					and iev.ValueTypeDescr = 'BaseYear4Event')
 
----------------------
-- Import_ROM
----------------------
-- 8489 rows in Import_ROM: Duplicate modifiers LPID Attribute

        ;With DupMod As (
		Select r4.ModDescr
              , r4.RevObjId
              , r4.StartDate
              , r4.EndDate
              , r4.LPID
              , Row_Number() Over(Partition By r4.ModDescr, r4.RevObjId, R4.LPID Order By r4.StartDate Asc) As [RowNumber]
		From Import_ROM r4
		)
		Select p.ModDescr
		, p.RevObjId
		, p.StartDate As [NewStartDate]
		, s.EndDate As [PreviousEndDate]
		, p.LPID
		From DupMod p
		inner join DupMod s on p.ModDescr = s.ModDescr and p.RevObjId = s.RevObjId and s.RowNumber = (p.RowNumber - 1) and p.LPID = s.LPID
		inner join (select shortdescr,attributetype from modifier where attributetype=470434 group by shortdescr,attributetype) m on m.shortdescr=p.moddescr
		Where p.RowNumber > 1 and p.StartDate <= IsNull(s.EndDate, '12/31/9999')
		Order By p.RowNumber
    
 
-- 23 rows in Import_ROM: Import_ROM with BUILDERX modifier has Import_EventValue with a invalid date
SELECT r.RevObjId, v.EventDate,  v.ValueTypeDescr,  r.StartDate , r.EndDate
			FROM Import_ROM r
			LEFT OUTER JOIN  Import_EventValue v ON r.RevObjId = v.RevObjId AND 'BuilderXFlag' =  v.ValueTypeDescr and r.pin=v.pin
		WHERE r.ModDescr = 'BUILDERX'
			AND 
				(
				v.EventDate IS NULL
					OR 
				(v.EventDate < r.StartDate AND v.EventDate > r.EndDate)
					OR 
				v.EventDate < r.StartDate AND r.EndDate	IS NULL	)
		
 
-- 1 rows in Import_ROM: Missing Building values on institutional modifiers

        Declare @v_VTAttributeType_RPAObject1 int; Exec dbo.aa_GetSysTypeId 'VTAttributeType', 'RPAObject', @v_VTAttributeType_RPAObject1 Output;
        Select r.ModDescr
         , r.RevObjId
        from Import_ROM r
        join Modifier m on r.ModDescr = m.ShortDescr
            and m.AttributeType = @v_VTAttributeType_RPAObject1
        join Import_ApplSite_Parcel asp
            on asp.RevObjId = r.RevObjId
            and asp.ObjectType in ('Building')
        left outer join Import_RPA_Value v on v.ASN = asp.ASN and v.BldNbr = asp.BldNbr
        Where v._rowid_ Is Null
        Group by r.ModDescr, r.RevObjId
    
 
-- 2 rows in Import_ROM: Missing Feature values on institutional modifiers

        Declare @v_VTAttributeType_RPAObject3 int; Exec dbo.aa_GetSysTypeId 'VTAttributeType', 'RPAObject', @v_VTAttributeType_RPAObject3 Output;
        Select r.ModDescr
         , r.RevObjId
        from Import_ROM r
        join Modifier m on r.ModDescr = m.ShortDescr
            and m.AttributeType = @v_VTAttributeType_RPAObject3
        join Import_ApplSite_Parcel asp
            on asp.RevObjId = r.RevObjId
            and asp.ObjectType in ('Feature')
        left outer join Import_RPA_Value v on v.ASN = asp.ASN and v.FeatureNbr = asp.FeatureNbr
        Where v._rowid_ Is Null
        Group by r.ModDescr, r.RevObjId
    
 
-- 1374 rows in Import_ROM: Missing Import_ROM HOX Modifiers for Import_EventValue HOX valuetypes
SELECT AsmtId, RevObjId, TaxYear, EventDate, ValueTypeDescr, RevObjId
		from import_eventvalue ev 
		where ev.valuetypedescr = 'HOX' 
		and not exists (select 1 from import_rom r where ev.revobjid = r.revobjid and ev.eventdate between r.startdate and isnull(r.enddate,'12/31/9999'))

		
 
-- 39261 rows in Import_ROM: Missing PPA SummaryGroups ObjectTypes for Personal Property Insitutional Modifiers

        Declare @v_Institutional_ModifierType2 int; Exec grm_GetSysTypeId 'ModifierType' , 'Institutional' , @v_Institutional_ModifierType2 OUTPUT;
        Declare @v_SysTypeCat_SumGroup int; Select @v_SysTypeCat_SumGroup = stc.Id From grm_FW_SysTypeCatByEffDate('12/31/2999', NULL) stc Where stc.ShortDescr = 'SumGroup'
        Declare @v_GetDate2 datetime = GetDate();
        Select r.RevObjId
         , r.ModDescr
         , r.ObjectType
         , m.ModifierType
         , ro.RevObjType
        From Import_Rom r
        join Modifier m on r.ModDescr = m.ShortDescr
        and m.ModifierType = @v_Institutional_ModifierType2
        inner join Import_RevObj ro on r.RevObjId = ro.TranKey and ro.RevObjType = 'Filing'
        Where ObjectType not in (Select ShortDescr From dbo.grm_FW_SysTypeByEffDate(@v_GetDate2, 'A') Where SysTypeCatId = @v_SysTypeCat_SumGroup)--230020
    
 
-- 228893 rows in Import_ROM: Missing RPA Object ObjectTypes for Real Property Insitutional Modifiers

        Declare @v_Institutional_ModifierType1 int; Exec grm_GetSysTypeId 'ModifierType' , 'Institutional' , @v_Institutional_ModifierType1 OUTPUT;
        Declare @v_SysTypeCat_SummaryGrp int; Select @v_SysTypeCat_SummaryGrp = stc.Id From grm_FW_SysTypeCatByEffDate('12/31/2999', NULL) stc Where stc.ShortDescr = 'SummaryGrp'
        Declare @v_GetDate1 datetime = GetDate();
        Select r.ModDescr
         , r.RevObjId
        From Import_Rom r
        join Modifier m on r.ModDescr = m.ShortDescr
        and m.ModifierType = @v_Institutional_ModifierType1
        inner join Import_RevObj ro on r.RevObjId = ro.TranKey and ro.RevObjType = 'Parcel'
        Where ObjectType not in (Select ShortDescr From dbo.grm_FW_SysTypeByEffDate(@v_GetDate1, 'A') Where SysTypeCatId = @v_SysTypeCat_SummaryGrp)--270102
    
 
-- 101959 rows in Import_ROM: Rom End Date is Valid for Legal Party Role
SELECT rom.ModDescr, rom.RevObjId, rom.ModDescr, rom.LPID, rom.StartDate, lpid.startdate, lpid.enddate, rom.EndDate  	FROM Import_ROM rom 		INNER JOIN Modifier m on rom.ModDescr = m.ShortDescr 		INNER JOIN conv_Validation_LPID_StartEndDates lpid ON rom.RevObjId = lpid.TranKey AND rom.LPID = lpid.LPID 	WHERE m.AttributeType =  470434		AND ( rom.EndDate > lpid.enddate				AND											 lpid.enddate IS NOT NULL					)										OR  rom.EndDate < lpid.startdate	
 
-- 122519 rows in Import_ROM: Rom Start Date is Valid for Legal Party Role
SELECT rom.ModDescr, rom.RevObjId, rom.ModDescr, rom.LPID, rom.StartDate, lpid.startdate, lpid.enddate, rom.EndDate  	FROM Import_ROM rom 		INNER JOIN Modifier m on rom.ModDescr = m.ShortDescr 		INNER JOIN conv_Validation_LPID_StartEndDates lpid ON rom.RevObjId = lpid.TranKey AND rom.LPID = lpid.LPID 	WHERE m.AttributeType = 470434		AND rom.StartDate < lpid.startdate 		OR ( rom.StartDate > lpid.enddate 			AND 			lpid.enddate IS NOT NULL  			)	 
 
------------------------------------------
-- HIGH
------------------------------------------
 
----------------------
-- Import_BVS
----------------------
-- 2401 rows in Import_BVS: Split or Merge Import_Event missing corresponding Import_EventBVS row
DECLARE @v_8years AS Date = DATEADD(year, -8, GETDATE()) SELECT * 	FROM Import_Event e 	WHERE e.EventType IN ('Split', 'Merge')		AND NOT EXISTS (						SELECT * 							FROM Import_EventBVS bvs 							WHERE bvs.RevObjId = e.RevObjID 								AND bvs.AsmtId = e.AsmtId								AND bvs.EventId = e.EventId						)		AND e.EventDate >= @v_8years
 
----------------------
-- Import_EventBVS
----------------------
-- 33 rows in Import_EventBVS: BldNumber = 0 and BuildingValue <> 0
SELECT AsmtId, RevObjId, BldNumber, BuildingValue 	From Import_EventBVS
			Where BldNumber = 0 and BuildingValue <> 0
		
 
-- 2 rows in Import_EventBVS: Dupe Feature Numbers on the same AsmtId
select AsmtId, RevObjId, TaxYear, FeatureNbr  	FROM Import_EventBVS  	WHERE FeatureValue <> 0 		AND FeatureNbr <> 0 	GROUP BY AsmtId, RevObjId, TaxYear, FeatureNbr	HAVING COUNT(1) > 1
 
-- 1 rows in Import_EventBVS: FeatureNbr = 0 and FeatureValue <> 0
SELECT AsmtId, RevObjId, FeatureNbr, FeatureValue 	From Import_EventBVS
			Where FeatureNbr = 0 and FeatureValue <> 0
		
 
-- 11 rows in Import_EventBVS: LandLineNumber = 0 and LandValue <> 0
SELECT AsmtId, RevObjId, LandLineNumber, LandValue 	From Import_EventBVS
			Where LandLineNumber = 0 and landvalue <> 0
		
 
----------------------
-- Import_ROM
----------------------
-- 8489 rows in Import_ROM: Duplicate modifiers LPID Attribute

        ;With DupMod As (
		Select r4.ModDescr
              , r4.RevObjId
              , r4.StartDate
              , r4.EndDate
              , r4.LPID
              , Row_Number() Over(Partition By r4.ModDescr, r4.RevObjId, R4.LPID Order By r4.StartDate Asc) As [RowNumber]
		From Import_ROM r4
		)
		Select p.ModDescr
		, p.RevObjId
		, p.StartDate As [NewStartDate]
		, s.EndDate As [PreviousEndDate]
		, p.LPID
		From DupMod p
		inner join DupMod s on p.ModDescr = s.ModDescr and p.RevObjId = s.RevObjId and s.RowNumber = (p.RowNumber - 1) and p.LPID = s.LPID
		inner join (select shortdescr,attributetype from modifier where attributetype=470434 group by shortdescr,attributetype) m on m.shortdescr=p.moddescr
		Where p.RowNumber > 1 and p.StartDate <= IsNull(s.EndDate, '12/31/9999')
		Order By p.RowNumber
    
 
-- 23 rows in Import_ROM: Import_ROM with BUILDERX modifier has Import_EventValue with a invalid date
SELECT r.RevObjId, v.EventDate,  v.ValueTypeDescr,  r.StartDate , r.EndDate
			FROM Import_ROM r
			LEFT OUTER JOIN  Import_EventValue v ON r.RevObjId = v.RevObjId AND 'BuilderXFlag' =  v.ValueTypeDescr and r.pin=v.pin
		WHERE r.ModDescr = 'BUILDERX'
			AND 
				(
				v.EventDate IS NULL
					OR 
				(v.EventDate < r.StartDate AND v.EventDate > r.EndDate)
					OR 
				v.EventDate < r.StartDate AND r.EndDate	IS NULL	)
		
 
-- 1 rows in Import_ROM: Missing Building values on institutional modifiers

        Declare @v_VTAttributeType_RPAObject1 int; Exec dbo.aa_GetSysTypeId 'VTAttributeType', 'RPAObject', @v_VTAttributeType_RPAObject1 Output;
        Select r.ModDescr
         , r.RevObjId
        from Import_ROM r
        join Modifier m on r.ModDescr = m.ShortDescr
            and m.AttributeType = @v_VTAttributeType_RPAObject1
        join Import_ApplSite_Parcel asp
            on asp.RevObjId = r.RevObjId
            and asp.ObjectType in ('Building')
        left outer join Import_RPA_Value v on v.ASN = asp.ASN and v.BldNbr = asp.BldNbr
        Where v._rowid_ Is Null
        Group by r.ModDescr, r.RevObjId
    
 
-- 2 rows in Import_ROM: Missing Feature values on institutional modifiers

        Declare @v_VTAttributeType_RPAObject3 int; Exec dbo.aa_GetSysTypeId 'VTAttributeType', 'RPAObject', @v_VTAttributeType_RPAObject3 Output;
        Select r.ModDescr
         , r.RevObjId
        from Import_ROM r
        join Modifier m on r.ModDescr = m.ShortDescr
            and m.AttributeType = @v_VTAttributeType_RPAObject3
        join Import_ApplSite_Parcel asp
            on asp.RevObjId = r.RevObjId
            and asp.ObjectType in ('Feature')
        left outer join Import_RPA_Value v on v.ASN = asp.ASN and v.FeatureNbr = asp.FeatureNbr
        Where v._rowid_ Is Null
        Group by r.ModDescr, r.RevObjId
    
 
-- 1374 rows in Import_ROM: Missing Import_ROM HOX Modifiers for Import_EventValue HOX valuetypes
SELECT AsmtId, RevObjId, TaxYear, EventDate, ValueTypeDescr, RevObjId
		from import_eventvalue ev 
		where ev.valuetypedescr = 'HOX' 
		and not exists (select 1 from import_rom r where ev.revobjid = r.revobjid and ev.eventdate between r.startdate and isnull(r.enddate,'12/31/9999'))

		
 
-- 39261 rows in Import_ROM: Missing PPA SummaryGroups ObjectTypes for Personal Property Insitutional Modifiers

        Declare @v_Institutional_ModifierType2 int; Exec grm_GetSysTypeId 'ModifierType' , 'Institutional' , @v_Institutional_ModifierType2 OUTPUT;
        Declare @v_SysTypeCat_SumGroup int; Select @v_SysTypeCat_SumGroup = stc.Id From grm_FW_SysTypeCatByEffDate('12/31/2999', NULL) stc Where stc.ShortDescr = 'SumGroup'
        Declare @v_GetDate2 datetime = GetDate();
        Select r.RevObjId
         , r.ModDescr
         , r.ObjectType
         , m.ModifierType
         , ro.RevObjType
        From Import_Rom r
        join Modifier m on r.ModDescr = m.ShortDescr
        and m.ModifierType = @v_Institutional_ModifierType2
        inner join Import_RevObj ro on r.RevObjId = ro.TranKey and ro.RevObjType = 'Filing'
        Where ObjectType not in (Select ShortDescr From dbo.grm_FW_SysTypeByEffDate(@v_GetDate2, 'A') Where SysTypeCatId = @v_SysTypeCat_SumGroup)--230020
    
 
-- 228893 rows in Import_ROM: Missing RPA Object ObjectTypes for Real Property Insitutional Modifiers

        Declare @v_Institutional_ModifierType1 int; Exec grm_GetSysTypeId 'ModifierType' , 'Institutional' , @v_Institutional_ModifierType1 OUTPUT;
        Declare @v_SysTypeCat_SummaryGrp int; Select @v_SysTypeCat_SummaryGrp = stc.Id From grm_FW_SysTypeCatByEffDate('12/31/2999', NULL) stc Where stc.ShortDescr = 'SummaryGrp'
        Declare @v_GetDate1 datetime = GetDate();
        Select r.ModDescr
         , r.RevObjId
        From Import_Rom r
        join Modifier m on r.ModDescr = m.ShortDescr
        and m.ModifierType = @v_Institutional_ModifierType1
        inner join Import_RevObj ro on r.RevObjId = ro.TranKey and ro.RevObjType = 'Parcel'
        Where ObjectType not in (Select ShortDescr From dbo.grm_FW_SysTypeByEffDate(@v_GetDate1, 'A') Where SysTypeCatId = @v_SysTypeCat_SummaryGrp)--270102
    
 
-- 101959 rows in Import_ROM: Rom End Date is Valid for Legal Party Role
SELECT rom.ModDescr, rom.RevObjId, rom.ModDescr, rom.LPID, rom.StartDate, lpid.startdate, lpid.enddate, rom.EndDate  	FROM Import_ROM rom 		INNER JOIN Modifier m on rom.ModDescr = m.ShortDescr 		INNER JOIN conv_Validation_LPID_StartEndDates lpid ON rom.RevObjId = lpid.TranKey AND rom.LPID = lpid.LPID 	WHERE m.AttributeType =  470434		AND ( rom.EndDate > lpid.enddate				AND											 lpid.enddate IS NOT NULL					)										OR  rom.EndDate < lpid.startdate	
 
-- 122519 rows in Import_ROM: Rom Start Date is Valid for Legal Party Role
SELECT rom.ModDescr, rom.RevObjId, rom.ModDescr, rom.LPID, rom.StartDate, lpid.startdate, lpid.enddate, rom.EndDate  	FROM Import_ROM rom 		INNER JOIN Modifier m on rom.ModDescr = m.ShortDescr 		INNER JOIN conv_Validation_LPID_StartEndDates lpid ON rom.RevObjId = lpid.TranKey AND rom.LPID = lpid.LPID 	WHERE m.AttributeType = 470434		AND rom.StartDate < lpid.startdate 		OR ( rom.StartDate > lpid.enddate 			AND 			lpid.enddate IS NOT NULL  			)	 
 
------------------------------------------
-- MEDIUM
------------------------------------------
 
----------------------
-- import_Event
----------------------
-- 516540 rows in import_Event: Non-matching AsmtType (should be Unsecured) in Import_event compared to Import_ChargeHdr
select e.RevObjId, e.Taxyear, e.TaxBillNumber 
					from Import_Event e
					where e.asmttype = 'Secured' 
					and exists 
						(select 1 from import_chargehdr ch 
						 where e.revobjid = ch.RevObjId
						 and ch.RollDescr = 'Unsecured' 
						 and e.TaxBillNumber = ch.TaxBillNumber 
						 and ch.BillDateGroupDescr <> '2to1Conv')
						 group by  e.RevObjId, e.Taxyear, e.TaxBillNumber
 
------------------------------------------------------------------------
-- PPA (rpt_PPAImp_err.sql) run on 07/27/18
------------------------------------------------------------------------
 
------------------------------------------
-- LOW
------------------------------------------
 
----------------------
-- Import_RevObj
----------------------
-- 32832 rows in Import_RevObj: PPA Import_RevObj (RevObjType = Filing) rows with no Import_ROSitus
select * from Import_RevObj as ro 
				where not exists (select 1 from import_rositus ros where ros.trankey = ro.trankey)
					and ro.RevObjType = 'filing'
 
------------------------------------------------------------------------
-- RPA (rpt_RPA_imp_err.sql) run on 07/27/18
------------------------------------------------------------------------
 
------------------------------------------
-- CRITICAL
------------------------------------------
 
----------------------
-- Import_ApplSite
----------------------
-- 4 rows in Import_ApplSite: Missing Import_ApplSite_Parcel for existing Applsite
select *
								from Import_ApplSite a
								where not exists (select 1 from import_applsite_parcel p 
												where p.ASN = a.ASN and p.BegEffDate = a.BegEffDate and ISNULL(p.DateDeleted,0) = ISNULL(a.DateDeleted,0)
												and p.objecttype = 'ApplSite')
 
----------------------
-- Import_ApplSite_Parcel
----------------------
-- 413 rows in Import_ApplSite_Parcel: Duplicate Import_ApplSite_Parcel
; with ImpAppSiteParcelRows as (
					select iasp.ASN
							, iasp.RevObjId
							, iasp.BegEffDate
							, iasp.ObjectType
							, Case
								 When iasp.ObjectType='ApplSite' then CAST(iasp.RevObjId as varchar)
								 When iasp.ObjectType='LandLine' then CAST(iasp.LandLineNbr as varchar)
								 When iasp.ObjectType='LandUse' then 'LandLine'+CAST(iasp.LandLineNbr as varchar)+' Land Use'+CAST(iasp.LandUseLineNbr as varchar) 
								 When iasp.ObjectType in ( 'Building', 'Bld' ) then CAST(iasp.BldNbr as varchar)+' BldSection'+CAST(iasp.BldSectionNbr as varchar)
								 When iasp.ObjectType='BldSection' then 'Bld'+CAST(iasp.BldNbr as varchar)+' BldSection'+CAST(iasp.BldSectionNbr as varchar)
								 When iasp.ObjectType='Feature' then CAST(iasp.FeatureNbr as varchar)
								 else  CAST(iasp._rowid_ as varchar)
							 end  as ObjectId
					from Import_ApplSite_Parcel as iasp
				)		select i.ASN
							, i.RevObjId
							, i.ObjectType
							, i.ObjectId
							, i.BegEffDate
						from ImpAppSiteParcelRows as i
						group by i.ASN
							, i.RevObjId
							, i.ObjectType
							, i.ObjectId
							, i.BegEffDate
						having count(*)>1
 
-- 3 rows in Import_ApplSite_Parcel: duplicate Import_ApplSite_Parcel: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_ApplSite_Parcel where ObjectType in ('Bld','BuildingSection'))
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 2 rows in Import_ApplSite_Parcel: duplicate Import_ApplSite_Parcel: LandLineNbr, LandUseLineNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, LandLineNbr, LandUseLineNbr, BegEffDate, ROW_NUMBER() over 
								(partition by ASN, LandLineNbr, LandUseLineNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
								order by ASN, LandLineNbr, LandUseLineNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') , BegEffDate) rownumber
									from Import_ApplSite_Parcel where ObjectType in ('LandLine','LandUseDetail') )
							   select ASN, ASN asn1, LandLineNbr, LandUseLineNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 139 rows in Import_ApplSite_Parcel: Import_ApplSite_Parcel EffStatus <> Import_RevObj EffStatus

				; with SrcRows as 
				(
					select distinct iasp.ASN
						, iasp.RevObjID
						, iasp.BegEffDate
						, iasp.DateDeleted
						, CASE 
							WHEN iro.EffStatus is null then 'RevObjID does not exist'
							WHEN iro.EffStatus <> (CASE 
														WHEN iasp.DateDeleted is null THEN 'A' 
														ELSE 'I'
													END
													 ) 
								THEN 'Import_RevObj & Import_ApplSite_Parcel statuses do not match'
						END AS ErrMsg
					FROM Import_ApplSite_Parcel as iasp
					LEFT JOIN Import_RevObj AS iro ON iro.Trankey = iasp.RevObjID
													AND iro.SeqNo = 
														(
															select max( iro_sub.SeqNo )
															from Import_RevObj as iro_sub
															where iro_sub.Trankey = iro.Trankey
														) 
					WHERE iasp.BegEffDate = 
								( 
									select max( isub.BegEffDate )
									from Import_ApplSite_Parcel as isub
									where isub.RevObjID = iasp.RevObjID
										and isub.ASN = iasp.ASN
										and iasp.ObjectType = 'ApplSite'
								)
				)
				SELECT 1 
					FROM SrcRows
					WHERE ErrMsg IS NOT NULL
						AND RevObjID NOT IN ( SELECT RevObjID 
												FROM  Import_RevObj ro 
												WHERE ro.trankey in 
													(SELECT TranKey 
														FROM (SELECT TranKey 
																FROM Import_RevObj 
																GROUP BY TranKey
															  ) tmp 
														GROUP BY TranKey
														HAVING COUNT(*) > 1
													 )
											 )
				
 
-- 69 rows in Import_ApplSite_Parcel: Missing Child Import_Bld for Import_ApplSite_Parcel
select ASN, BegEffDate, DateDeleted, BldNbr from Import_ApplSite_Parcel where Import_ApplSite_Parcel.ObjectType = 'Building' and not exists (select 1 from Import_Bld where Import_ApplSite_Parcel.asn=Import_Bld.asn and Import_ApplSite_Parcel.Begeffdate=Import_Bld.Begeffdate and isnull(Import_ApplSite_Parcel.DateDeleted,'7-4-1776')=isnull(Import_Bld.DateDeleted,'7-4-1776') and Import_ApplSite_Parcel.BldNbr=Import_Bld.BldNbr)
 
-- 2 rows in Import_ApplSite_Parcel: Missing DateDeleted Import_feature
SELECT i.ASN ,i.FeatureNbr ,i.BegEffDate ,i.DateDeleted  
				FROM import_applSite_parcel i 
				WHERE i.ObjectType= 'Feature' and Coalesce(i.DateDeleted,'') <> '' 
					AND exists (
								SELECT * 
									from import_feature ift 
									where ift.asn = i.asn 
									and ift.featureNbr=i.featureNbr 
									and ift.BegEffDate = i.BegEffDate 
									and coalesce(ift.DateDeleted,'') = '') 
				
				ORDER BY ASN, FeatureNbr
 
----------------------
-- Import_Bld
----------------------
-- 4 rows in Import_Bld: DateDeleted <= BegEffDate (Import_Bld)
select ASN, BldNbr,BldSectionNbr,LandLineNum, BegEffDate, DateDeleted from Import_Bld where DateDeleted <= BegEffDate order by 1,2,3
 
-- 143 rows in Import_Bld: Duplicate import_bld rows
select asn, bldnbr, BldSectionNbr, begEffdate from import_bld group by asn, bldnbr, BldSectionNbr, begEffdate having count(1) > 1
 
-- 143 rows in Import_Bld: duplicate Import_Bld: BldNbr, BldSectionNbr (based off of BegEffDate)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, BegEffDate
									 order by ASN, BldNbr, BldSectionNbr, BegEffDate) rownumber
								from Import_Bld)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 264 rows in Import_Bld: duplicate Import_Bld: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_Bld)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 8 rows in Import_Bld: Missing Child ApplSite_Parcel for BldSection
select ASN,BldNbr,BldSectionNbr from Import_Bld where not exists(select * from Import_ApplSite_Parcel where Import_Bld.asn=Import_ApplSite_Parcel.asn and Import_Bld.BldNbr=Import_ApplSite_Parcel.BldNbr and Import_Bld.BldSectionNbr=Import_ApplSite_Parcel.BldSectionNbr and Import_ApplSite_Parcel.ObjectType in ('BldSection', 'BuildingSection'))
 
----------------------
-- Import_BldSize
----------------------
-- 218 rows in Import_BldSize: duplicate Import_BldSizeSize: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr,sizetype, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_BldSize where FeatureNbr = 0)
								select ASN, BldNbr, BldSectionNbr, BegEffDate, sizetype
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 115 rows in Import_BldSize: duplicate Import_BldSizeSize: BldNbr, BldSectionNbr, sizetype (based off of BegEffDate)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype
									 order by ASN, BldNbr, BldSectionNbr, BegEffDate) rownumber
								from Import_BldSize where FeatureNbr = 0)
								select ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 2 rows in Import_BldSize: duplicate Import_BldSizeSize: Feature (based off of BegEffDate)
select  asn, begeffdate, featureNbr, sizeType from Import_BldSize where FeatureNbr > 0 group by asn, begeffdate, featureNbr, sizeType having count(1) > 1
 
-- 341 rows in Import_BldSize: Missing BuildingSection for Building size
select * from Import_BldSize bs where not exists (select 1 from import_bld b where b.asn = bs.asn and b.BldNbr = bs.BldNbr and b.BldSectionNbr = bs.BldSectionNbr and b.BegEffDate <= bs.BegEffDate) and bs.ObjectType = 'BuildingUse'
 
----------------------
-- Import_BldUse
----------------------
-- 93 rows in Import_BldUse: duplicate Import_BldUse: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_BldUse)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 56 rows in Import_BldUse: for duplicate Import_BldUse: BldNbr, BldSectionNbr (based off of BegEffDate)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, BegEffDate
									 order by ASN, BldNbr, BldSectionNbr, BegEffDate) rownumber
								from Import_BldUse)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 29 rows in Import_BldUse: Import_BldUse and Import_BldSize line up with Import_BldUse as the master table
	select * from Import_BldUse bu
								left outer join Import_BldSize bs
									ON	bu.ASN = bs.ASN
									AND bu.BldNbr = bs.BldNbr
									AND bu.BldSectionNbr = bs.BldSectionNbr
									and bu.begEffDate = bs.BegEffDate
									AND bu.UseNbr = bs.UseNbr
									AND bu.FloorType = bs.FloorType
									AND bu.FloorNbr = bs.FloorNbr
									AND (bs.FeatureNbr = 0 or bs.FeatureNbr is null)
								where bs.ASN is null
 
-- 245 rows in Import_BldUse: Missing Parent Building for Building Use
select ASN from Import_BldUse where BldSectionNbr is not null and BldSectionNbr<>0 and not exists(select * from Import_Bld where Import_Bld.asn=Import_BldUse.asn and Import_Bld.BldNbr=Import_BldUse.BldNbr and Import_Bld.BldSectionNbr=Import_BldUse.BldSectionNbr and import_bld.BegEffDate <= Import_BldUse.BegEffDate) order by 1
 
----------------------
-- Import_Feature
----------------------
-- 3 rows in Import_Feature: Duplicate Feature
select asn, begeffdate, featurenbr, bldnbr, bldsectionnbr, cd, count(*) from import_Feature as f group by asn, begeffdate, featurenbr, bldnbr, bldsectionnbr, cd having count(*)>1 order by 1,2,3,4,5
 
-- 2 rows in Import_Feature: Import_Feature.FeatureNbr mismatch with Import_ApplSite_Parcel
DECLARE @v_8years AS DateTime = DateAdd(year, -8, GetDate())SELECT * 	FROM Import_Feature f  	WHERE NOT EXISTS 		( 		SELECT * 			FROM Import_ApplSite_Parcel ap  			WHERE  ap.ASN = f.ASN  				AND ISNULL(ap.DateDeleted,0) = ISNULL(f.DateDeleted,0) 				AND ap.FeatureNbr = f.FeatureNbr 				AND ap.ObjectType = 'Feature' 		) 		AND f.BegEffDate > @v_8years
 
-- 2 rows in Import_Feature: Missing Child ApplSite_Parcel for Feature
select ASN,FeatureNbr from Import_Feature where not exists(select * from Import_ApplSite_Parcel where Import_Feature.asn=Import_ApplSite_Parcel.asn and Import_Feature.FeatureNbr=Import_ApplSite_Parcel.FeatureNbr and Import_ApplSite_Parcel.ObjectType = 'Feature')
 
-- 2 rows in Import_Feature: Missing Parent ASN for Features
select ASN from Import_Feature where not exists (select * from Import_ApplSite where Import_ApplSite.asn=Import_Feature.asn) order by 1
 
----------------------
-- Import_IncomeSurvey
----------------------
-- 11 rows in Import_IncomeSurvey: Missing Parent Import_ApplSite
select * from Import_IncomeSurvey as i where not exists(select * from Import_ApplSite as isub where isub.ASN = i.ASN) order by 1,2
 
----------------------
-- Import_Land	
----------------------
-- 10 rows in Import_Land	: Missing DateDeleted Import_Land
select * from import_applSite_parcel i where i.ObjectType= 'LandLine' and coalesce(i.DateDeleted,'') <> '' and i.BegEffDate = (Select max(BegEffDate) from import_applSite_parcel isub where isub.ASN = I.ASN and isub.ObjectType= 'LandLine') and exists (select * from Import_Land il where il.asn = i.asn and il.LandLineNbr=i.LandLineNbr and coalesce(il.DateDeleted,'') = '')
 
----------------------
-- Import_Land
----------------------
-- 2 rows in Import_Land: DateDeleted <= BegEffDate (Import_Land)
select ASN,LandLineNbr, BegEffDate, DateDeleted from Import_Land where DateDeleted <= BegEffDate order by 1,2,3
 
-- 1019 rows in Import_Land: Missing Import_ApplSite_Parcel for an existing LandLine
select *
								from import_land a
								where not exists (select 1 from import_applsite_parcel p where p.ASN = a.ASN and p.LandLineNbr = a.LandLineNbr
													and p.BegEffDate = a.BegEffDate and ISNULL(p.DateDeleted,0) = ISNULL(a.DateDeleted,0)
													and p.objecttype = 'LandLine')
 
----------------------
-- Import_LandUseDetail
----------------------
-- 878 rows in Import_LandUseDetail: Missing Parent  Import_ApplSite_Parcel for Import_LandUseDetail
select ASN, BegEffDate, DateDeleted,LandLineNbr,LandUseLineNbr 
						from Import_LandUseDetail 
						where  not exists 
							(select * from Import_ApplSite_Parcel 
							where Import_LandUseDetail.asn=Import_ApplSite_Parcel.asn 
							and Import_ApplSite_Parcel.Begeffdate=Import_LandUseDetail.Begeffdate 
							and isnull(Import_ApplSite_Parcel.DateDeleted,0)=isnull(Import_LandUseDetail.DateDeleted,0) 
							and Import_LandUseDetail.LandLineNbr=Import_ApplSite_Parcel.LandLineNbr 
							and Import_LandUseDetail.LandUseLineNbr=Import_ApplSite_Parcel.LandUseLineNbr 
							and Import_ApplSite_Parcel.ObjectType = 'LandUseDetail')
 
----------------------
-- Import_RPA_SitusAddr
----------------------
-- 2 rows in Import_RPA_SitusAddr: DateDeleted <= BegEffDate (Import_RPA_SitusAddr)
select ASN, BldNbr, PermitNumber, SitusNbr,BegEffDate, DateDeleted from Import_RPA_SitusAddr where DateDeleted <= BegEffDate order by 1,2,3,4,5
 
-- 2 rows in Import_RPA_SitusAddr: Missing Parent ASN for Situs Addr
select ASN from Import_RPA_SitusAddr where not exists(select * from Import_ApplSite where Import_ApplSite.asn=Import_RPA_SitusAddr.asn) order by 1
 
----------------------
-- Import_RPA_Value
----------------------
-- 1705 rows in Import_RPA_Value: Duplicate Import_RPA_Value
; with ImpRows as (
								select ASN, ImportRowType, BegEffDate, RevObjId, ReasonCd, ValueInfoType, 
										case ImportRowType 
											when 'L' then coalesce( cast( LandLineNbr as varchar ), '' )  
											when 'B' then coalesce( cast( BldNbr as varchar ), '' ) + coalesce( cast( BldSectionNbr as varchar ), '' ) 
											when 'F' then coalesce( cast( FeatureNbr as varchar ), '' ) 
											when 'U' then coalesce( cast( LandLineNbr as varchar ), '' ) + coalesce( cast( LandUseLineNbr as varchar ), '' ) 
											when '' then ASN 
										end as ObjectId 
									from Import_RPA_Value 
									) 
									select ASN, ImportRowType, BegEffDate, RevObjId, ReasonCd, ValueInfoType, ObjectId, count(*) 
										from ImpRows 
										group by ASN, ImportRowType, BegEffDate, RevObjId, REasonCd, ValueInfoType, ObjectId 
										having count(*) > 1
 
-- 45 rows in Import_RPA_Value: Missing Parent ASN for Import_RPA_Value
 select * from Import_RPA_Value as i where not exists( select * from Import_ApplSite as isub where isub.ASN = i.ASN ) order by 1,2,3,4
 
-- 50 rows in Import_RPA_Value: Missing Parent Feature for Import_RPA_Value
select * from Import_RPA_Value as i where ImportRowType='F' and FeatureNbr is not null and FeatureNbr<>0 and not exists (select * from Import_Feature where Import_Feature.asn=i.asn and Import_Feature.FeatureNbr=i.FeatureNbr) order by 1,2,3,4
 
-- 1 rows in Import_RPA_Value: Transfers no RPA_value
SELECT lpr.Trankey, od.DocDate 
				FROM Import_LPR lpr       
					JOIN import_OD od ON od.TranKey = lpr.TranKey AND od.SeqNo = lpr.SeqNo
				WHERE lpr.ReAppraisability = 'Reappraise'     
					AND NOT EXISTS (
									SELECT 1 
										FROM Import_RPA_Value i
										WHERE i.RevObjId = lpr.Trankey
											AND CAST(i.BegEffDate AS DATE) = CAST(od.DocDate AS DATE) 
											AND i.ReasonCd IN ('RPTransfer','DirectEnrollment','SS','SL','SV')
									)                                          
					AND NOT EXISTS (
									SELECT 1 
										FROM import_flag if1 
										WHERE if1.ObjectId = lpr.Trankey and if1.ObjectType = 'Revobj'
											AND if1.flagtype in ( 'unvaluedtransfer', 'NoDoc')
											AND if1.RevObjId = lpr.Trankey
												)
				AND od.DocDate >= DATEADD(YEAR,-8,GETDATE())
				AND exists (select 1 from Import_ApplSite_Parcel ap where ap.RevObjId = od.TranKey and ap.ObjectType in  ('Building','LandLine','Feature') )
				AND not exists (select 1 from Import_RevObj ro where ro.TranKey = od.TranKey and ro.EffStatus = 'I')
				GROUP BY lpr.Trankey, od.DocDate
				
 
------------------------------------------
-- HIGH
------------------------------------------
 
----------------------
-- Import_ApplSite_Parcel
----------------------
-- 413 rows in Import_ApplSite_Parcel: Duplicate Import_ApplSite_Parcel
; with ImpAppSiteParcelRows as (
					select iasp.ASN
							, iasp.RevObjId
							, iasp.BegEffDate
							, iasp.ObjectType
							, Case
								 When iasp.ObjectType='ApplSite' then CAST(iasp.RevObjId as varchar)
								 When iasp.ObjectType='LandLine' then CAST(iasp.LandLineNbr as varchar)
								 When iasp.ObjectType='LandUse' then 'LandLine'+CAST(iasp.LandLineNbr as varchar)+' Land Use'+CAST(iasp.LandUseLineNbr as varchar) 
								 When iasp.ObjectType in ( 'Building', 'Bld' ) then CAST(iasp.BldNbr as varchar)+' BldSection'+CAST(iasp.BldSectionNbr as varchar)
								 When iasp.ObjectType='BldSection' then 'Bld'+CAST(iasp.BldNbr as varchar)+' BldSection'+CAST(iasp.BldSectionNbr as varchar)
								 When iasp.ObjectType='Feature' then CAST(iasp.FeatureNbr as varchar)
								 else  CAST(iasp._rowid_ as varchar)
							 end  as ObjectId
					from Import_ApplSite_Parcel as iasp
				)		select i.ASN
							, i.RevObjId
							, i.ObjectType
							, i.ObjectId
							, i.BegEffDate
						from ImpAppSiteParcelRows as i
						group by i.ASN
							, i.RevObjId
							, i.ObjectType
							, i.ObjectId
							, i.BegEffDate
						having count(*)>1
 
-- 3 rows in Import_ApplSite_Parcel: duplicate Import_ApplSite_Parcel: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_ApplSite_Parcel where ObjectType in ('Bld','BuildingSection'))
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 2 rows in Import_ApplSite_Parcel: duplicate Import_ApplSite_Parcel: LandLineNbr, LandUseLineNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, LandLineNbr, LandUseLineNbr, BegEffDate, ROW_NUMBER() over 
								(partition by ASN, LandLineNbr, LandUseLineNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
								order by ASN, LandLineNbr, LandUseLineNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') , BegEffDate) rownumber
									from Import_ApplSite_Parcel where ObjectType in ('LandLine','LandUseDetail') )
							   select ASN, ASN asn1, LandLineNbr, LandUseLineNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 139 rows in Import_ApplSite_Parcel: Import_ApplSite_Parcel EffStatus <> Import_RevObj EffStatus

				; with SrcRows as 
				(
					select distinct iasp.ASN
						, iasp.RevObjID
						, iasp.BegEffDate
						, iasp.DateDeleted
						, CASE 
							WHEN iro.EffStatus is null then 'RevObjID does not exist'
							WHEN iro.EffStatus <> (CASE 
														WHEN iasp.DateDeleted is null THEN 'A' 
														ELSE 'I'
													END
													 ) 
								THEN 'Import_RevObj & Import_ApplSite_Parcel statuses do not match'
						END AS ErrMsg
					FROM Import_ApplSite_Parcel as iasp
					LEFT JOIN Import_RevObj AS iro ON iro.Trankey = iasp.RevObjID
													AND iro.SeqNo = 
														(
															select max( iro_sub.SeqNo )
															from Import_RevObj as iro_sub
															where iro_sub.Trankey = iro.Trankey
														) 
					WHERE iasp.BegEffDate = 
								( 
									select max( isub.BegEffDate )
									from Import_ApplSite_Parcel as isub
									where isub.RevObjID = iasp.RevObjID
										and isub.ASN = iasp.ASN
										and iasp.ObjectType = 'ApplSite'
								)
				)
				SELECT 1 
					FROM SrcRows
					WHERE ErrMsg IS NOT NULL
						AND RevObjID NOT IN ( SELECT RevObjID 
												FROM  Import_RevObj ro 
												WHERE ro.trankey in 
													(SELECT TranKey 
														FROM (SELECT TranKey 
																FROM Import_RevObj 
																GROUP BY TranKey
															  ) tmp 
														GROUP BY TranKey
														HAVING COUNT(*) > 1
													 )
											 )
				
 
-- 69 rows in Import_ApplSite_Parcel: Missing Child Import_Bld for Import_ApplSite_Parcel
select ASN, BegEffDate, DateDeleted, BldNbr from Import_ApplSite_Parcel where Import_ApplSite_Parcel.ObjectType = 'Building' and not exists (select 1 from Import_Bld where Import_ApplSite_Parcel.asn=Import_Bld.asn and Import_ApplSite_Parcel.Begeffdate=Import_Bld.Begeffdate and isnull(Import_ApplSite_Parcel.DateDeleted,'7-4-1776')=isnull(Import_Bld.DateDeleted,'7-4-1776') and Import_ApplSite_Parcel.BldNbr=Import_Bld.BldNbr)
 
-- 2 rows in Import_ApplSite_Parcel: Missing DateDeleted Import_feature
SELECT i.ASN ,i.FeatureNbr ,i.BegEffDate ,i.DateDeleted  
				FROM import_applSite_parcel i 
				WHERE i.ObjectType= 'Feature' and Coalesce(i.DateDeleted,'') <> '' 
					AND exists (
								SELECT * 
									from import_feature ift 
									where ift.asn = i.asn 
									and ift.featureNbr=i.featureNbr 
									and ift.BegEffDate = i.BegEffDate 
									and coalesce(ift.DateDeleted,'') = '') 
				
				ORDER BY ASN, FeatureNbr
 
----------------------
-- Import_Bld
----------------------
-- 4 rows in Import_Bld: DateDeleted <= BegEffDate (Import_Bld)
select ASN, BldNbr,BldSectionNbr,LandLineNum, BegEffDate, DateDeleted from Import_Bld where DateDeleted <= BegEffDate order by 1,2,3
 
-- 143 rows in Import_Bld: Duplicate import_bld rows
select asn, bldnbr, BldSectionNbr, begEffdate from import_bld group by asn, bldnbr, BldSectionNbr, begEffdate having count(1) > 1
 
-- 143 rows in Import_Bld: duplicate Import_Bld: BldNbr, BldSectionNbr (based off of BegEffDate)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, BegEffDate
									 order by ASN, BldNbr, BldSectionNbr, BegEffDate) rownumber
								from Import_Bld)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 264 rows in Import_Bld: duplicate Import_Bld: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_Bld)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 8 rows in Import_Bld: Missing Child ApplSite_Parcel for BldSection
select ASN,BldNbr,BldSectionNbr from Import_Bld where not exists(select * from Import_ApplSite_Parcel where Import_Bld.asn=Import_ApplSite_Parcel.asn and Import_Bld.BldNbr=Import_ApplSite_Parcel.BldNbr and Import_Bld.BldSectionNbr=Import_ApplSite_Parcel.BldSectionNbr and Import_ApplSite_Parcel.ObjectType in ('BldSection', 'BuildingSection'))
 
----------------------
-- Import_BldSize
----------------------
-- 218 rows in Import_BldSize: duplicate Import_BldSizeSize: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr,sizetype, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_BldSize where FeatureNbr = 0)
								select ASN, BldNbr, BldSectionNbr, BegEffDate, sizetype
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 115 rows in Import_BldSize: duplicate Import_BldSizeSize: BldNbr, BldSectionNbr, sizetype (based off of BegEffDate)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype
									 order by ASN, BldNbr, BldSectionNbr, BegEffDate) rownumber
								from Import_BldSize where FeatureNbr = 0)
								select ASN, BldNbr, BldSectionNbr, BegEffDate,sizetype
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 2 rows in Import_BldSize: duplicate Import_BldSizeSize: Feature (based off of BegEffDate)
select  asn, begeffdate, featureNbr, sizeType from Import_BldSize where FeatureNbr > 0 group by asn, begeffdate, featureNbr, sizeType having count(1) > 1
 
-- 341 rows in Import_BldSize: Missing BuildingSection for Building size
select * from Import_BldSize bs where not exists (select 1 from import_bld b where b.asn = bs.asn and b.BldNbr = bs.BldNbr and b.BldSectionNbr = bs.BldSectionNbr and b.BegEffDate <= bs.BegEffDate) and bs.ObjectType = 'BuildingUse'
 
----------------------
-- Import_BldUse
----------------------
-- 93 rows in Import_BldUse: duplicate Import_BldUse: BldNbr, BldSectionNbr (based off of DateDeleted)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000') 
									 order by ASN, BldNbr, BldSectionNbr, COALESCE(DateDeleted,'1776-07-04 00:00:00.000'), BegEffDate) rownumber
								from Import_BldUse)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 56 rows in Import_BldUse: for duplicate Import_BldUse: BldNbr, BldSectionNbr (based off of BegEffDate)
;with duplicates as
								(select ASN, BldNbr, BldSectionNbr, BegEffDate, ROW_NUMBER() over 
									(partition by ASN, BldNbr, BldSectionNbr, BegEffDate
									 order by ASN, BldNbr, BldSectionNbr, BegEffDate) rownumber
								from Import_BldUse)
								select ASN, BldNbr, BldSectionNbr, BegEffDate
								from duplicates where rownumber > 1 order by 1,2,3
 
-- 29 rows in Import_BldUse: Import_BldUse and Import_BldSize line up with Import_BldUse as the master table
	select * from Import_BldUse bu
								left outer join Import_BldSize bs
									ON	bu.ASN = bs.ASN
									AND bu.BldNbr = bs.BldNbr
									AND bu.BldSectionNbr = bs.BldSectionNbr
									and bu.begEffDate = bs.BegEffDate
									AND bu.UseNbr = bs.UseNbr
									AND bu.FloorType = bs.FloorType
									AND bu.FloorNbr = bs.FloorNbr
									AND (bs.FeatureNbr = 0 or bs.FeatureNbr is null)
								where bs.ASN is null
 
-- 245 rows in Import_BldUse: Missing Parent Building for Building Use
select ASN from Import_BldUse where BldSectionNbr is not null and BldSectionNbr<>0 and not exists(select * from Import_Bld where Import_Bld.asn=Import_BldUse.asn and Import_Bld.BldNbr=Import_BldUse.BldNbr and Import_Bld.BldSectionNbr=Import_BldUse.BldSectionNbr and import_bld.BegEffDate <= Import_BldUse.BegEffDate) order by 1
 
----------------------
-- Import_Feature
----------------------
-- 3 rows in Import_Feature: Duplicate Feature
select asn, begeffdate, featurenbr, bldnbr, bldsectionnbr, cd, count(*) from import_Feature as f group by asn, begeffdate, featurenbr, bldnbr, bldsectionnbr, cd having count(*)>1 order by 1,2,3,4,5
 
-- 2 rows in Import_Feature: Import_Feature.FeatureNbr mismatch with Import_ApplSite_Parcel
DECLARE @v_8years AS DateTime = DateAdd(year, -8, GetDate())SELECT * 	FROM Import_Feature f  	WHERE NOT EXISTS 		( 		SELECT * 			FROM Import_ApplSite_Parcel ap  			WHERE  ap.ASN = f.ASN  				AND ISNULL(ap.DateDeleted,0) = ISNULL(f.DateDeleted,0) 				AND ap.FeatureNbr = f.FeatureNbr 				AND ap.ObjectType = 'Feature' 		) 		AND f.BegEffDate > @v_8years
 
-- 2 rows in Import_Feature: Missing Child ApplSite_Parcel for Feature
select ASN,FeatureNbr from Import_Feature where not exists(select * from Import_ApplSite_Parcel where Import_Feature.asn=Import_ApplSite_Parcel.asn and Import_Feature.FeatureNbr=Import_ApplSite_Parcel.FeatureNbr and Import_ApplSite_Parcel.ObjectType = 'Feature')
 
-- 2 rows in Import_Feature: Missing Parent ASN for Features
select ASN from Import_Feature where not exists (select * from Import_ApplSite where Import_ApplSite.asn=Import_Feature.asn) order by 1
 
----------------------
-- Import_Land
----------------------
-- 2 rows in Import_Land: DateDeleted <= BegEffDate (Import_Land)
select ASN,LandLineNbr, BegEffDate, DateDeleted from Import_Land where DateDeleted <= BegEffDate order by 1,2,3
 
-- 1019 rows in Import_Land: Missing Import_ApplSite_Parcel for an existing LandLine
select *
								from import_land a
								where not exists (select 1 from import_applsite_parcel p where p.ASN = a.ASN and p.LandLineNbr = a.LandLineNbr
													and p.BegEffDate = a.BegEffDate and ISNULL(p.DateDeleted,0) = ISNULL(a.DateDeleted,0)
													and p.objecttype = 'LandLine')
 
----------------------
-- Import_Permit
----------------------
-- 2 rows in Import_Permit: Duplicate Import_Permit

						; with ImpRows as (
							select ASN
								, RevObjId
								, ObjectType
								,case when ObjectType in ( 'Building', 'Bld' ) then coalesce( cast( BldNbr as varchar ), '' )
										when ObjectType='BldSection' then coalesce( cast( BldNbr as varchar ), '' ) + coalesce( cast( bldSectionNbr as varchar ), '' )
										when ObjectType = 'Feature' then coalesce( cast( FeatureNbr as varchar ), '' )
										else ASN
									end					as ObjectId
								, PermitNumber
								, BegEffdate
							from Import_Permit
						)
				SELECT ASN , RevObjId, PermitNumber, ObjectType, ObjectId, BegEffDate 
					FROM ImpRows 
					group by ASN, RevObjId, PermitNumber, ObjectType, ObjectId, BegEffDate
					having count(*) > 1
				
 
----------------------
-- Import_RPA_Value
----------------------
-- 1705 rows in Import_RPA_Value: Duplicate Import_RPA_Value
; with ImpRows as (
								select ASN, ImportRowType, BegEffDate, RevObjId, ReasonCd, ValueInfoType, 
										case ImportRowType 
											when 'L' then coalesce( cast( LandLineNbr as varchar ), '' )  
											when 'B' then coalesce( cast( BldNbr as varchar ), '' ) + coalesce( cast( BldSectionNbr as varchar ), '' ) 
											when 'F' then coalesce( cast( FeatureNbr as varchar ), '' ) 
											when 'U' then coalesce( cast( LandLineNbr as varchar ), '' ) + coalesce( cast( LandUseLineNbr as varchar ), '' ) 
											when '' then ASN 
										end as ObjectId 
									from Import_RPA_Value 
									) 
									select ASN, ImportRowType, BegEffDate, RevObjId, ReasonCd, ValueInfoType, ObjectId, count(*) 
										from ImpRows 
										group by ASN, ImportRowType, BegEffDate, RevObjId, REasonCd, ValueInfoType, ObjectId 
										having count(*) > 1
 
-- 45 rows in Import_RPA_Value: Missing Parent ASN for Import_RPA_Value
 select * from Import_RPA_Value as i where not exists( select * from Import_ApplSite as isub where isub.ASN = i.ASN ) order by 1,2,3,4
 
-- 50 rows in Import_RPA_Value: Missing Parent Feature for Import_RPA_Value
select * from Import_RPA_Value as i where ImportRowType='F' and FeatureNbr is not null and FeatureNbr<>0 and not exists (select * from Import_Feature where Import_Feature.asn=i.asn and Import_Feature.FeatureNbr=i.FeatureNbr) order by 1,2,3,4
 
-- 1 rows in Import_RPA_Value: Transfers no RPA_value
SELECT lpr.Trankey, od.DocDate 
				FROM Import_LPR lpr       
					JOIN import_OD od ON od.TranKey = lpr.TranKey AND od.SeqNo = lpr.SeqNo
				WHERE lpr.ReAppraisability = 'Reappraise'     
					AND NOT EXISTS (
									SELECT 1 
										FROM Import_RPA_Value i
										WHERE i.RevObjId = lpr.Trankey
											AND CAST(i.BegEffDate AS DATE) = CAST(od.DocDate AS DATE) 
											AND i.ReasonCd IN ('RPTransfer','DirectEnrollment','SS','SL','SV')
									)                                          
					AND NOT EXISTS (
									SELECT 1 
										FROM import_flag if1 
										WHERE if1.ObjectId = lpr.Trankey and if1.ObjectType = 'Revobj'
											AND if1.flagtype in ( 'unvaluedtransfer', 'NoDoc')
											AND if1.RevObjId = lpr.Trankey
												)
				AND od.DocDate >= DATEADD(YEAR,-8,GETDATE())
				AND exists (select 1 from Import_ApplSite_Parcel ap where ap.RevObjId = od.TranKey and ap.ObjectType in  ('Building','LandLine','Feature') )
				AND not exists (select 1 from Import_RevObj ro where ro.TranKey = od.TranKey and ro.EffStatus = 'I')
				GROUP BY lpr.Trankey, od.DocDate
				
 
----------------------
-- Import_SiteChar
----------------------
-- 26 rows in Import_SiteChar: DateDeleted <= BegEffDate (Import_SiteChar)
select ASN,BegEffDate, DateDeleted from Import_SiteChar where DateDeleted <= BegEffDate order by 1,2,3
 
------------------------------------------------------------------------
-- CM (rpt_CM_imp_err.sql) run on 07/27/18
------------------------------------------------------------------------
 
------------------------------------------
-- HIGH
------------------------------------------
 
----------------------
-- Import_CaseGroupCaseParty
----------------------
-- 1 rows in Import_CaseGroupCaseParty: Import_CaseGroupCaseParty.CPID not in import_CaseParty
select * from Import_CaseGroupCaseParty cgcp where not exists(select 1 from import_CaseParty cp where cgcp.CPID = cp.CPID)
 
-- 1 rows in Import_CaseGroupCaseParty: Import_CaseGroupCaseParty.GroupNumber not in import_CaseRecord
select * from Import_CaseGroupCaseParty cgcp where not exists(select 1 from import_CaseRecord cr where cgcp.GroupNumber = cr.GroupNumber)
 
----------------------
-- Import_CaseParty
----------------------
-- 1 rows in Import_CaseParty: Import_CaseParty.CPID not in Import_CaseGroupCaseParty
select * from import_CaseParty cp where not exists(select 1 from Import_CaseGroupCaseParty cgcp where cgcp.CPID = cp.CPID)
 
------------------------------------------------------------------------
-- IPP (rpt_PmtPlan_err.sql) run on 07/27/18
------------------------------------------------------------------------
 
------------------------------------------
-- CRITICAL
------------------------------------------
 
----------------------
-- Import_PmtPlanChrg
----------------------
-- 884215 rows in Import_PmtPlanChrg: invalid PmtPlan in Import_PmtPlanChrg
select 'Import_PmtPlanChrg no valid PmtPlan: ' Error, ippc.RevObjId, ippc.PlanNumber from Import_PmtPlanChrg ippc where not exists
					(select 1 from Import_PmtPlan ipp where ippc.RevObjId = ipp.RevObjId and ippc.PlanNumber = ipp.PlanNumber)
 
----------------------
-- Import_PmtPlanPmt
----------------------
-- 45 rows in Import_PmtPlanPmt: Import_PmtPlanPmt.Amount > 0
select amount, * from Import_PmtPlanPmt where amount > 0
 
-- 2 rows in Import_PmtPlanPmt: PlanNumber that are tied to multiple RevObjs
select a.PlanNumber
						from Import_PmtPlan a
						join Import_PmtPlan b on a.PlanNumber = b.PlanNumber
						where a.RevObjId <> b.RevObjId and a.Status = 'Defaulted'
						group by a.PlanNumber
 
------------------------------------------
-- MEDIUM
------------------------------------------
 
----------------------
-- Import_PmtPlanPmt
----------------------
-- 45 rows in Import_PmtPlanPmt: Import_PmtPlanPmt.Amount > 0
select amount, * from Import_PmtPlanPmt where amount > 0
 
-- 2 rows in Import_PmtPlanPmt: PlanNumber that are tied to multiple RevObjs
select a.PlanNumber
						from Import_PmtPlan a
						join Import_PmtPlan b on a.PlanNumber = b.PlanNumber
						where a.RevObjId <> b.RevObjId and a.Status = 'Defaulted'
						group by a.PlanNumber
 
