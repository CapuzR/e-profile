
import Types "./types";

import Principal "mo:base/Principal";
import Trie "mo:base/Trie";
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Buffer "mo:base/Buffer";
import Nat "mo:base/Nat";
import Result "mo:base/Result";
import Uploader "./uploader/main";
import Static "./uploader/static";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import U "./utils";
import Blob "mo:base/Blob";
import Http "./uploader/http";


import Debug "mo:base/Debug";

import AID "./util/AccountIdentifier";


shared({ caller = owner }) actor class (
  initOptions : Types.InitOptions
) = weaveProfile {
    type ProfileUpdate = Types.ProfileUpdate;
    type Bio = Types.Bio;
    type Profile = Types.Profile;
    type Error = Types.Error;
    // type ProfileUpgrade = Types.ProfileUpgrade;

    type Holders = Types.Holders;

    type Result_1 = Types.Result_1;
    type TokenIndex = Types.TokenIndex;
    type CommonError = Types.CommonError;
    type AccountIdentifier__1 = Types.AccountIdentifier__1;

    // stable var profileUpgrade : [(Principal, ProfileUpgrade)] = [];

    stable var profiles : Trie.Trie<Principal, Profile> = Trie.empty();

    stable var admins : [Principal] = initOptions.admins;


    stable var staticAssetsEntries : [(
        Text,        // Asset Identifier (path).
        Static.Asset // Asset data.
    )] = [];
    
    let staticAssets = Static.Assets(staticAssetsEntries);
    
    system func preupgrade() {

//Below commented code (Including postupgrade commented code and stable var profileUpgrade) is an example of how to upgrade canister when Profile Type change.
//   1. Complete the userProfile object below with the data that is going to complete already existing registries on production.
//   2. Deploy code without enabling the type changes.
//   3. Add type changes.
//   4. Deploy change to the IC and voilà.

        // let usersProfileArr : [(Principal, ProfileUpgrade)] = [];
        // for( v in Trie.iter(profiles) ) {
        //     let userProfile : ProfileUpgrade = {
        //         bio = {
        //             about = v.1.bio.about; 
        //             displayName = v.1.bio.displayName; 
        //             email = v.1.bio.email; 
        //             familyName = v.1.bio.familyName; 
        //             givenName = v.1.bio.givenName; 
        //             location = v.1.bio.location; 
        //             phone = v.1.bio.phone; 
        //             socials = v.1.bio.socials; 
        //             username = v.1.bio.username;
        //             test = "Temp";
        //         };
        //         id = v.0;
        //     };

        //     profileUpgrade := Array.append(profileUpgrade, [(v.0, userProfile)]);

        // };
        staticAssetsEntries := Iter.toArray(staticAssets.entries());
    };

    system func postupgrade() {
        staticAssetsEntries := [];

        // for ( (x, y) in profileUpgrade.vals() ) {
        //     let temp = Trie.put(profiles, key(x), Principal.equal, y).0;
        //     profiles:= temp;
        // };
        // profileUpgrade := [];
    };

      public shared ({caller}) func addNewAdmin (principals : [Principal]) : async Result.Result<(), Types.Error> {
      
      if(not U.isAdmin(caller, admins)) {
          return #err(#NotAuthorized);
      };

      let adminsBuff : Buffer.Buffer<Principal> = Buffer.Buffer(0);
      
      for (admin in admins.vals()) {
        adminsBuff.add(admin);
      };

      for (principal in principals.vals()) {
        adminsBuff.add(principal);
      };
      
      admins := adminsBuff.toArray();
      return #ok(());

  };

    public shared(msg) func createProfile (profile: ProfileUpdate) : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;
        let textCallerId : Text = Principal.toText(callerId);

        // Reject AnonymousIdentity
        if(textCallerId == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        switch (profile.avatarRequest) {
            case (#Put(data)) {
                if( textCallerId != data.key ) {
                    return #err(#NotAuthorized); 
                }
            }; 
            case (#Remove(_)) { 
                return #err(#InvalidRequest); 
            }; 
            case (#StagedWrite(_)) {
                return #err(#InvalidRequest); 
            };
        };

        //Static Asset (avatar image) store.
        switch (await staticAssets.handleRequest(profile.avatarRequest)) {
            case (#ok())   {

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
            case (#err(e)) { #err(#FailedToWrite(e)); };
        };
    };

    public query(msg) func readProfile () : async Result.Result<(?Profile, ?Static.Asset), Error> {
        // Get caller principal
        let callerId = msg.caller;
        let textCallerId : Text = Principal.toText(callerId);

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        let result : ?Profile = Trie.find(
            profiles,           //Target Trie
            key(callerId),      // Key
            Principal.equal     // Equality Checker
        );
        
        switch (result){
            case null {
                #err(#NotFound)
            };
            case (? v) {
                switch(staticAssets.getToken(textCallerId)) {
                    case (#err(_)) { 
                        #ok((result, null));
                    };
                    case (#ok(v))  {
                        #ok((result, ?{ contentType = v.contentType; payload = v.payload }));
                    };
                };
            };
        };
    };

    public shared(msg) func updateProfile (profile : ProfileUpdate) : async Result.Result<(), Error> {
        // Get caller principal
        let callerId = msg.caller;
        let textCallerId : Text = Principal.toText(callerId);

        // Reject AnonymousIdentity
        if(Principal.toText(callerId) == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        switch (profile.avatarRequest) {
            case (#Put(data)) {
                if( textCallerId != data.key ) {
                    return #err(#NotAuthorized); 
                }
            }; 
            case (#Remove(_)) { 
                return #err(#InvalidRequest); 
            }; 
            case (#StagedWrite(_)) {
                return #err(#InvalidRequest); 
            };
        };

        //Static Asset (avatar image) store.
        switch (await staticAssets.handleRequest(profile.avatarRequest)) {
            case (#ok())   {
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
            case (#err(e)) { #err(#FailedToWrite(e)); };
        };
    };

    // Delete profile
    public shared(msg) func deleteProfile (avatarRequest : Static.AssetRequest) : async Result.Result<(), Error> {
        let callerId = msg.caller;
        let textCallerId : Text = Principal.toText(callerId);

        // Reject AnonymousIdentity
        if(textCallerId == "2vxsx-fae") {
            return #err(#NotAuthorized);
        };

        switch (avatarRequest) {
            case (#Remove(data)) {
                if( textCallerId != data.key ) {
                    return #err(#NotAuthorized); 
                }
            }; 
            case (#Put(_)) { 
                return #err(#InvalidRequest); 
            }; 
            case (#StagedWrite(_)) {
                return #err(#InvalidRequest); 
            };
        };

        //Static Asset (avatar image) store.
        switch (await staticAssets.handleRequest(avatarRequest)) {
            case (#ok())   {
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
            case (#err(e)) { #err(#FailedToWrite(e)); };
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
    };

    public shared({caller}) func getAllProfiles(): async Result.Result<[(Principal, Profile)], Types.Error> 
    {
    if(not U.isAdmin(caller, admins)) {
        return #err(#NotAuthorized);
    }else {
    var resultProfiles = Iter.toArray(Trie.iter(profiles));
    return #ok(resultProfiles);
    };
    };

    public shared({caller}) func getAdmins(): async Result.Result<[Principal], Types.Error>{
            if(not U.isAdmin(caller, admins)) {
                return #err(#NotAuthorized);
            }else {
                return #ok(admins);
            };
    };

    // HTTP interface

    public query func http_request(request : Http.Request) : async Http.Response {
        let path = Iter.toArray(Text.tokens(request.url, #text("/")));

        return staticAssets.get(path[0], staticStreamingCallback);
    };

    public query func http_request_streaming_callback(
        tk : Http.StreamingCallbackToken
    ) : async Http.StreamingCallbackResponse {
        switch (staticAssets.getToken(tk.key)) {
            case (#err(_)) { 
                return {
                    body  = Blob.fromArray([]); 
                    token = null;
                };
            };
            case (#ok(v))  {
                return Http.streamContent(
                    tk.key, 
                    tk.index, 
                    v.payload,
                );
            };
        };
    };

    // A streaming callback based on static assets.
    // Returns {[], null} if the asset can not be found.
    public query func staticStreamingCallback(tk : Http.StreamingCallbackToken) : async Http.StreamingCallbackResponse {
        switch(staticAssets.getToken(tk.key)) {
            case (#err(_)) { };
            case (#ok(v))  {
                return Http.streamContent(
                    tk.key,
                    tk.index,
                    v.payload,
                );
            };
        };
        {
            body = Blob.fromArray([]);
            token = null;
        };
    };
};
