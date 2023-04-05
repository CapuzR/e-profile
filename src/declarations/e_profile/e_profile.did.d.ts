import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface Asset {
  'contentType' : string,
  'payload' : Array<Uint8Array | number[]>,
}
export type AssetRequest = {
    'Put' : {
      'key' : string,
      'contentType' : string,
      'callback' : [] | [Callback],
      'payload' : { 'StagedData' : null } |
        { 'Payload' : Uint8Array | number[] },
    }
  } |
  { 'Remove' : { 'key' : string, 'callback' : [] | [Callback] } } |
  { 'StagedWrite' : WriteAsset };
export interface Bio {
  'familyName' : [] | [string],
  'about' : [] | [string],
  'username' : [] | [string],
  'displayName' : [] | [string],
  'socials' : [] | [Socials],
  'givenName' : [] | [string],
  'email' : [] | [string],
  'phone' : [] | [string],
  'location' : [] | [string],
}
export type Callback = ActorMethod<[], undefined>;
export interface CeSo {
  'tiktok' : [] | [string],
  'twitter' : [] | [string],
  'instagram' : [] | [string],
  'facebook' : [] | [string],
  'discord' : [] | [string],
}
export type CommonError = { 'InvalidToken' : TokenIdentifier } |
  { 'Other' : string };
export interface DeSo {
  'distrikt' : [] | [string],
  'dscvr' : [] | [string],
  'openChat' : [] | [string],
}
export type Error = { 'Immutable' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'Unauthorized' : null } |
  { 'AlreadyExists' : null } |
  { 'InvalidRequest' : null } |
  { 'AuthorizedPrincipalLimitReached' : bigint } |
  { 'FailedToWrite' : string };
export type Error__1 = { 'Immutable' : null } |
  { 'NotFound' : null } |
  { 'NotAuthorized' : null } |
  { 'Unauthorized' : null } |
  { 'AlreadyExists' : null } |
  { 'InvalidRequest' : null } |
  { 'AuthorizedPrincipalLimitReached' : bigint } |
  { 'FailedToWrite' : string };
export type HeaderField = [string, string];
export interface InitOptions { 'admins' : Array<Principal> }
export interface Profile { 'id' : Principal, 'bio' : Bio }
export interface ProfileUpdate { 'bio' : Bio, 'avatarRequest' : AssetRequest }
export interface Request {
  'url' : string,
  'method' : string,
  'body' : Uint8Array | number[],
  'headers' : Array<HeaderField>,
}
export interface Response {
  'body' : Uint8Array | number[],
  'headers' : Array<HeaderField>,
  'streaming_strategy' : [] | [StreamingStrategy],
  'status_code' : number,
}
export type Result = { 'ok' : null } |
  { 'err' : Error };
export type Result_1 = { 'ok' : [[] | [Profile], [] | [Asset]] } |
  { 'err' : Error };
export type Result_2 = { 'ok' : Array<string> } |
  { 'err' : CommonError };
export type Result_3 = { 'ok' : Array<[Principal, Profile]> } |
  { 'err' : Error__1 };
export type Result_4 = { 'ok' : Array<Principal> } |
  { 'err' : Error__1 };
export type Result_5 = { 'ok' : null } |
  { 'err' : Error__1 };
export interface Socials { 'ceSo' : [] | [CeSo], 'deSo' : [] | [DeSo] }
export type StreamingCallback = ActorMethod<
  [StreamingCallbackToken],
  StreamingCallbackResponse
>;
export interface StreamingCallbackResponse {
  'token' : [] | [StreamingCallbackToken],
  'body' : Uint8Array | number[],
}
export interface StreamingCallbackToken {
  'key' : string,
  'index' : bigint,
  'content_encoding' : string,
}
export type StreamingStrategy = {
    'Callback' : {
      'token' : StreamingCallbackToken,
      'callback' : StreamingCallback,
    }
  };
export type TokenIdentifier = string;
export type WriteAsset = {
    'Init' : { 'id' : string, 'size' : bigint, 'callback' : [] | [Callback] }
  } |
  {
    'Chunk' : {
      'id' : string,
      'chunk' : Uint8Array | number[],
      'callback' : [] | [Callback],
    }
  };
export interface anon_class_24_1 {
  'addNewAdmin' : ActorMethod<[Array<Principal>], Result_5>,
  'createProfile' : ActorMethod<[ProfileUpdate], Result>,
  'deleteProfile' : ActorMethod<[AssetRequest], Result>,
  'getAdmins' : ActorMethod<[], Result_4>,
  'getAllProfiles' : ActorMethod<[], Result_3>,
  'getDiscordHolders' : ActorMethod<[string], Result_2>,
  'http_request' : ActorMethod<[Request], Response>,
  'http_request_streaming_callback' : ActorMethod<
    [StreamingCallbackToken],
    StreamingCallbackResponse
  >,
  'readProfile' : ActorMethod<[], Result_1>,
  'staticStreamingCallback' : ActorMethod<
    [StreamingCallbackToken],
    StreamingCallbackResponse
  >,
  'updateProfile' : ActorMethod<[ProfileUpdate], Result>,
}
export interface _SERVICE extends anon_class_24_1 {}
