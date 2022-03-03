## To create multiple identities and test properly:

 `dfx identity new gega`

 `dfx identity new capuzr`

Read Profile

 dfx --identity XYZ canister call weaveProfile readProfile '()'

Update Profile

 dfx --identity XYZ canister call weaveProfile updateProfile '(record {bio=record {familyName=opt "Capuz"; about=opt "Capuz is just Capuz"; username=opt "capuzr"; displayName=opt "capuzr"; socials=opt record {ceSo=opt record {twitter=opt "capuzr"; instagram=opt "capuzr"; facebook=opt "capuzr"; discord=opt "capuzr#2678"}; deSo=opt record {distrikt=opt "capuzr"; dscvr=opt "capuzr"; openChat=opt "capuzr"}}; givenName=opt "Ricardo"; email=opt "capuzr@gmail.com"; phone=opt "584143201028"; location=opt "Caracas, Venezuela"}})'

Create Profile

 dfx --identity XYZ canister call weaveProfile createProfile '(record {bio=record {familyName=opt "Capuz"; about=opt "Capuz is just Capuz"; username=opt "capuzr"; displayName=opt "capuzr"; givenName=opt "Ricardo"; email=opt "capuzr@gmail.com"; phone=opt "+58 4143201028"; location=opt "Caracas, Venezuela"}})'

Delete Profile

 dfx --identity XYZ canister call weaveProfile deleteProfile '()'


With Avatar

## Create new Profile

    ` dfx --identity default canister call weaveProfile createProfile '(record {bio=record {familyName=opt "Capuz"; about=opt "Capuz is just Capuz"; username=opt "capuzr"; displayName=opt "capuzr"; givenName=opt "Ricardo"; email=opt "capuzr@gmail.com"; phone=opt "+58 4143201028"; location=opt "Caracas, Venezuela"}; avatarRequest=variant { Put=record{ key= "m5spm-rypb4-5dh4x-cfmly-f2ngh-qjvm4-wyntp-kbhfk-5mhn7-ag65r-qae"; contentType= "image/jpeg"; payload = variant{ Payload = vec{ 0x00 } } } } })' `

    ` dfx --identity maru canister call weaveProfile createProfile '(record {bio=record {familyName=opt "Alvarez"; about=opt "Maru is just Madu"; username=opt "maru"; displayName=opt "maru"; givenName=opt "Maria"; email=opt "malvarez@gmail.com"; phone=opt "+58 4242490166"; location=opt "Caracas, Venezuela"}; avatarRequest=variant { Put=record{ key= "ocuph-ade3f-6t6zc-3b3ro-txsga-yuxai-km3af-7jksl-ysuwj-grbdo-lae"; contentType= "image/jpeg"; payload = variant{ Payload = vec{ 0x02 } } } } })' `


## Update Profile

    ` dfx --identity default canister call weaveProfile updateProfile '(record {bio=record {familyName=opt "Capuz"; about=opt "Capuz is just Capuz"; username=opt "capuzr"; displayName=opt "capuzr"; givenName=opt "Ricardo"; email=opt "capuzr@gmail.com"; phone=opt "+58 4143201028"; location=opt "Caracas, Venezuela"}; avatarRequest=variant { Put=record{ key= "fdr6g-skcxd-bselb-bngx2-znbfp-ok2lj-hsuw6-fts73-nxguv-uc3sn-fae"; contentType= "image/jpeg"; payload = variant{ Payload = vec{ 0x0000 } } } } })' `

## Delete profile

    ` dfx --identity default canister call weaveProfile deleteProfile '(variant { Remove=record{ key= "fdr6g-skcxd-bselb-bngx2-znbfp-ok2lj-hsuw6-fts73-nxguv-uc3sn-fae"; }})' `
