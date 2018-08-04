-- for window period new construction the delta amount in RPA is doubled
-- update the amount in Import_RPA_Value for Buildings
-- 07/31/2018 rows = 55,630
SELECT A.PIN
      ,cast(A.EventDate as date) as EventDate
      ,ValueTypeDescr
      ,Attribute1
      ,Attribute3
      ,cast(a.ValueAmount as decimal) as EventVal_ValueAmt
      ,cast(r.ValueAmount as decimal) as RPAVal_ValueAmount
      ,cast(a.ValueAmount as decimal) as New_RPAVal_ValueAmt
      ,r._RowId_ Upd_RowId
FROM Import_EventValue as A
Join Import_RPA_Value R
on    r.pin           = a.pin
   and r.BldNbr        = a.Attribute3
   and r.ImportRowType = 'b'
   and r.BegEffDate    = a.EventDate
   and r.ReasonCd      = 'RPNewConst'
   and r.ValueInfoType = 'NewConstruction'       
Where a.valuetypedescr = 'NewConst '
and a.Attribute1      = 'Building'
and a.ValueAmount * 2 = r.ValueAmount
and a.ValueAmount   <> 0
Group by a.pin, a.EventDate, a.ValueTypeDescr, a.Attribute1, a.Attribute3, a.ValueAmount
        ,r.ValueAmount, r._RowId_ 
Order by A.pin, A.eventdate
--
-- for window period new construction the delta amount in RPA is doubled
-- update the amount in Import_RPA_Value for Land
-- 07/31/2018 rows = 1,468
SELECT A.PIN
      ,cast(A.EventDate as date) as EventDate
      ,ValueTypeDescr
      ,Attribute1
      ,Attribute3
      ,cast(a.ValueAmount as decimal) as EventVal_ValueAmt
      ,cast(r.ValueAmount as decimal) as RPAVal_ValueAmount
      ,cast(a.ValueAmount as decimal) as New_RPAVal_ValueAmt
      ,r._RowId_ Upd_RowId
FROM Import_EventValue as A
Join Import_RPA_Value R
on    r.pin           = a.pin
   and r.LandLIneNbr   = a.Attribute3
   and r.ImportRowType = 'L'
   and r.BegEffDate    = a.EventDate
   and r.ReasonCd      = 'RPNewConst'
   and r.ValueInfoType = 'NewConstruction'       
Where a.valuetypedescr = 'NewConst '
and a.Attribute1      = 'LandLine'
and a.ValueAmount * 2 = r.ValueAmount
and a.ValueAmount   <> 0
Group by a.pin, a.EventDate, a.ValueTypeDescr, a.Attribute1, a.Attribute3, a.ValueAmount
        ,r.ValueAmount, r._RowId_ 
Order by A.pin, A.eventdate
--
--
-- for window period new construction the delta amount in RPA is doubled
-- update the amount in Import_RPA_Value for LivImp
-- 07/31/2018 rows = 2
SELECT A.PIN
      ,cast(A.EventDate as date) as EventDate
      ,ValueTypeDescr
      ,Attribute1
      ,Attribute3
      ,cast(a.ValueAmount as decimal) as EventVal_ValueAmt
      ,cast(r.ValueAmount as decimal) as RPAVal_ValueAmount
      ,cast(a.ValueAmount as decimal) as New_RPAVal_ValueAmt
      ,r._RowId_ Upd_RowId
FROM Import_EventValue as A
Join Import_RPA_Value R
on    r.pin           = a.pin
   and r.FeatureNbr    = a.Attribute3
   and r.ImportRowType = 'F'
   and r.BegEffDate    = a.EventDate
   and r.ReasonCd      = 'RPNewConst'
   and r.ValueInfoType = 'NewConstruction'       
Where a.valuetypedescr = 'NewConst '
and a.Attribute1      = 'LivImp'
and a.ValueAmount * 2 = r.ValueAmount
and a.ValueAmount   <> 0
Group by a.pin, a.EventDate, a.ValueTypeDescr, a.Attribute1, a.Attribute3, a.ValueAmount
        ,r.ValueAmount, r._RowId_ 
Order by A.pin, A.eventdate
--
--
-- for window period new construction the delta amount in RPA is doubled
-- update the amount in Import_RPA_Value for Feature
-- 07/31/2018 rows = 480
SELECT A.PIN
      ,cast(A.EventDate as date) as EventDate
      ,ValueTypeDescr
      ,Attribute1
      ,Attribute3
      ,cast(a.ValueAmount as decimal) as EventVal_ValueAmt
      ,cast(r.ValueAmount as decimal) as RPAVal_ValueAmount
      ,cast(a.ValueAmount as decimal) as New_RPAVal_ValueAmt
      ,r._RowId_ Upd_RowId
FROM Import_EventValue as A
Join Import_RPA_Value R
on    r.pin           = a.pin
   and r.FeatureNbr    = a.Attribute3
   and r.ImportRowType = 'F'
   and r.BegEffDate    = a.EventDate
   and r.ReasonCd      = 'RPNewConst'
   and r.ValueInfoType = 'NewConstruction'       
Where a.valuetypedescr = 'NewConst '
and a.Attribute1      = 'Feature'
and a.ValueAmount * 2 = r.ValueAmount
and a.ValueAmount   <> 0
Group by a.pin, a.EventDate, a.ValueTypeDescr, a.Attribute1, a.Attribute3, a.ValueAmount
        ,r.ValueAmount, r._RowId_ 
Order by A.pin, A.eventdate
