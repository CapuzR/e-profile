E_PROFILE_PATH=$ELEMENTUM_PATH"/general/e-profile"

cd $E_PROFILE_PATH

if [ $E_PROFILE_ENV = "local" ] 
then
    dfx canister create e_profile >/dev/null
fi

echo $(dfx canister id e_profile);

dfx build --network $E_PROFILE_ENV e_profile >/dev/null

if [ $INSTALL_MODE = "none" ]
then
    dfx canister install --network $E_PROFILE_ENV e_profile --argument '(
        record { 
            admins = vec {
                principal "'$ADMINS_PRINCIPAL_0'";
                principal "'$ADMINS_PRINCIPAL_1'"
            }
        }
    )' >/dev/null
else
    dfx canister install --mode $INSTALL_MODE --network $E_PROFILE_ENV e_profile --argument '(
        record { 
            admins = vec {
                principal "'$ADMINS_PRINCIPAL_0'";
                principal "'$ADMINS_PRINCIPAL_1'"
            }
        }
    )' >/dev/null
fi

dfx generate e_profile >/dev/null