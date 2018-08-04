--There is an issue where the second transfer is not being converted.

select top 10 * from OfficialDoc where docnumber = '2017-0450855' --(no record imported)

select * from import_od where trankey = 359390001 and seqno in(17, 18)
select * from import_revobj where trankey = 359390001
select * from import_lpr where trankey = 359390001 and seqno = 18


select * from conv_od where trankey = 359390001
select * from officialdoc where id in (7838981,7838982)

select * from import_od where trankey = 359410014 and seqno = 18
select * from import_revobj where trankey = 359410014
select * from import_lpr where trankey = 359410014 and seqno = 18


select top 10 * from righttransferdetail
select top 10 * from righthist
select top 10 * from right
