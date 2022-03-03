import Static "./uploader/static";

module {
//Profile

    public type CeSo = {
        discord: ?Text;
        twitter: ?Text;
        instagram: ?Text;
        facebook: ?Text;
        tiktok: ?Text;
    };

    public type DeSo = {
        distrikt: ?Text;
        dscvr: ?Text;
        openChat: ?Text;
    };

    public type Socials = {
        deSo: ?DeSo;
        ceSo: ?CeSo;
    };

    public type Bio = {
        givenName: ?Text;
        familyName: ?Text;
        username: ?Text;
        displayName: ?Text;
        location: ?Text;
        about: ?Text;
        email: ?Text;
        phone: ?Text;
        socials: ?Socials;
        // test: Text;
    };

    public type Profile = {
        bio: Bio;
        id: Principal;
    };
    
    public type ProfileUpdate = {
        bio: Bio;
        avatarRequest: Static.AssetRequest;
    };

    public type Error = {
        #AlreadyExists;
        #NotAuthorized;
        #Unauthorized;
        #NotFound;
        #InvalidRequest;
        #AuthorizedPrincipalLimitReached : Nat;
        #Immutable;
        #FailedToWrite : Text;
    };

    public type Holders = {
        discord: ?Text;
        isHolder: ?Bool;
    };

    //Aditional types
    public type Result_1 = { #ok : [TokenIndex]; #err : CommonError };
    public type TokenIndex = Nat32;
    public type CommonError = { #InvalidToken : TokenIdentifier; #Other : Text };
    public type TokenIdentifier = Text;
    public type AccountIdentifier__1 = Text;


//Upgrade types

    // public type ProfileUpgrade = {
    //     bio: BioUpgrade;
    //     id: Principal;
    // };

    // public type BioUpgrade = {
    //     givenName: ?Text;
    //     familyName: ?Text;
    //     username: ?Text;
    //     displayName: ?Text;
    //     location: ?Text;
    //     about: ?Text;
    //     email: ?Text;
    //     phone: ?Text;
    //     socials: ?Socials;
    //     test: Text;
    // };
};
