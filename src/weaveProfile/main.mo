
import Types "./types";

import Principal "mo:base/Principal";
import Trie "mo:base/Trie";
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Result "mo:base/Result";

import Debug "mo:base/Debug";

import AID "./util/AccountIdentifier";


actor {

    type ProfileUpdate = Types.ProfileUpdate;
    type Bio = Types.Bio;
    type Profile = Types.Profile;
    type Error = Types.Error;

    type Holders = Types.Holders;

    type Result_1 = Types.Result_1;
    type TokenIndex = Types.TokenIndex;
    type CommonError = Types.CommonError;
    type AccountIdentifier__1 = Types.AccountIdentifier__1;

    stable var profiles : Trie.Trie<Principal, Profile> = Trie.empty();

    public shared(msg) func createProfile (profile: ProfileUpdate) : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        // Associate user profile with their principal
        let userProfile: Profile = {
            bio = profile.bio;
            id = callerId;
        };

        let (newProfiles, existing) = Trie.put(
            profiles,           // Target trie
            key(callerId),      // Key
            Principal.equal,    // Equality checker
            userProfile
        );

        // If there is an original value, do not update
        switch(existing) {
            // If there are no matches, update profiles
            case null {
                profiles := newProfiles;
                #ok(());
            };
            // Matches pattern of type - opt Profile
            case (? v) {
                #err(#AlreadyExists);
            };
        };
    };

    public shared(msg) func readProfile () : async Result.Result<Profile, Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        let result = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );
        return Result.fromOption(result, #NotFound);
    };


    public shared(msg) func updateProfile (profile : ProfileUpdate) : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        // Associate user profile with their principal
        let userProfile: Profile = {
            bio = profile.bio;
            id = callerId;
        };

        let result = Trie.find(
            profiles,           //Target Trie
            key(callerId),     // Key
            Principal.equal           // Equality Checker
        );

        switch (result){
            // Do not allow updates to profiles that haven't been created yet
            case null {
                #err(#NotFound)
            };
            case (? v) {
                profiles := Trie.replace(
                    profiles,           // Target trie
                    key(callerId),      // Key
                    Principal.equal,    // Equality checker
                    ?userProfile
                ).0;
                #ok(());
            };
        };
    };

    // Delete profile
    public shared(msg) func deleteProfile () : async Result.Result<(), Error> {
        let callerId = msg.caller;

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        let result = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );

        switch (result){
            // Do not try to delete a profile that hasn't been created yet
            case null {
                #err(#NotFound);
            };
            case (? v) {
                profiles := Trie.replace(
                    profiles,           // Target trie
                    key(callerId),     // Key
                    Principal.equal,          // Equality checker
                    null
                ).0;
                #ok(());
            };
        };
    };

    private func key(x : Principal) : Trie.Key<Principal> {
        return { key = x; hash = Principal.hash(x) }
    };

    public shared(msg) func getDiscordHolders ( canisterId : Text ) : async  Result.Result<[Text], CommonError> {
        let callerId = msg.caller;

        let profs : [Profile] = Trie.toArray<Principal, Profile, Profile>(profiles, func (k, v) { v });
        var res : [Text] = [];

        label l for (p in profs.vals()) {
            switch (p.bio.socials) {
                case (null) {
                    continue l;
                };
                case (?so) {
                    switch (so.ceSo) {
                        case (null) {
                            continue l;
                        };
                        case (?ceSo) {
                            switch (ceSo.discord) {
                                case (null) {
                                    continue l;
                                };
                                case (?d) {
                                    let discord : Text = d;
                                    let toniqNftCanister = actor(canisterId): actor { tokens : shared query AccountIdentifier__1 -> async Result_1; };
                                    let result = await toniqNftCanister.tokens(AID.fromPrincipal(p.id, null));
                                    Debug.print(debug_show(result));
                                    switch (result) {
                                        case (#err InvalidToken) {
                                            continue l;
                                        };
                                        case (#ok valid) {
                                            res := Array.append(res, [d]);
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };
            // if(p.bio.socials == null) {
            //     if(p.bio.socials.ceSo == null) {
            //         if(p.bio.socials.ceSo.discord == null) {
            //             let discord : Text = p.bio.socials.ceSo.discord;
            //         };
            //     };
            // };
        };

        return #ok(res);
        // Reject AnonymousIdentity
        // if(Principal.toText(callerId) == "2vxsx-fae") {
        //     return #err(#Other("Not authorized"));
        // };await toniqNftCanister.tokens(AID.fromPrincipal(callerId, null));
    };
};
