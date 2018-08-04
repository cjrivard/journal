select * from [Service.BaseValueSegment].BVS where RevObjId = 303411010 and AsOf = '2017-01-09'
select * from [Service.BaseValueSegment].BVSTran where BVSId = 5575724

select * from [Service.BaseValueSegment].BVSValueHeader where BVSTranId = 5533371  --No records found
select * from [Service.BaseValueSegment].BVSValue where BVSValueHeaderId = '' --No record in BVSValueHeader to populate this table

select top 100 * from [Service.BaseValueSegment].BVSOwner where BVSTranId = 5533371
select * from [Service.BaseValueSegment].BVSOwnerValue where BVSOwnerId in (24009937, 24009938)  --No records found

select top 100 * from [Service.BaseValueSegment].BVSOwner where BIPercent not in (100, 50, 25)

select top 10 * from legalpartyrole where PercentBeneficialInt not in (100, 50, 25)


update [Service.BaseValueSegment].BVSOwner set BIPercent = 33.3400000000 where BIPercent = 33.3333333400


update [Service.BaseValueSegment].BVSOwner set BIPercent = 33.3300000000 where BIPercent = 33.3333333300

--103	42964	33.3400000000	0	1	297304	42964	0
select * from LegalPartyRole where id = 297304

select * from [Service.BaseValueSegment].BVSOwner bvs
join legalpartyrole lpr
on lpr.id = bvs.LegalPartyRoleId
where bvs.BIPercent <> lpr.PercentBeneficialInt