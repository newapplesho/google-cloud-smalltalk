Class {
	#name : 'GoogleAuthClientTest',
	#superclass : 'TestCase',
	#instVars : [
		'mockCredentialsLoader',
		'mockHttpClient',
		'client'
	],
	#category : 'Google-Auth-Tests-Core',
	#package : 'Google-Auth-Tests',
	#tag : 'Core'
}

{ #category : 'running' }
GoogleAuthClientTest >> setUp [

	super setUp.
	client := GoogleAuthClient new.
	mockCredentialsLoader := MockObject new.
	client credentialsLoader: mockCredentialsLoader.

	mockHttpClient := MockObject new.
	client httpClient: mockHttpClient
]

{ #category : 'tests' }
GoogleAuthClientTest >> testGetCredentialsForAuthorizedUser [

	| mockAdcContents expectedEntity responseJsonString expectedResponse |
	mockAdcContents := Dictionary new
		                   at: 'client_id' put: 'mock_client_id';
		                   at: 'client_secret' put: 'mock_client_secret';
		                   at: 'refresh_token' put: 'mock_refresh_token';
		                   at: 'type' put: 'authorized_user';
		                   yourself.

	mockCredentialsLoader
		on: #loadApplicationDefaultCredentials
		respond: mockAdcContents.

	expectedEntity := ZnApplicationFormUrlEncodedEntity new
		                  at: 'client_id' put: 'mock_client_id';
		                  at: 'client_secret' put: 'mock_client_secret';
		                  at: 'refresh_token' put: 'mock_refresh_token';
		                  at: 'grant_type' put: 'refresh_token';
		                  yourself.


	responseJsonString := '{ "access_token": "mock_access_token", "expires_in": 3600, "scope": "scope1 scope2", "token_type": "Bearer", "id_token": "mock_id_token" }'.
	mockHttpClient on: #httpPost:contents: respond: (ZnResponse new
			 statusLine: (ZnStatusLine new code: 200);
			 entity: (ZnEntity json: responseJsonString);
			 yourself).

	expectedResponse := client getCredentials.

	self assert: (expectedResponse isKindOf: GoogleOauth2RefreshResponse).
	self assert: (expectedResponse at: 'access_token') equals: 'mock_access_token'.
	self assert: (expectedResponse at: 'expires_in') equals: 3600.
	self assert: (expectedResponse at: 'scope') equals: 'scope1 scope2'.
	self assert: (expectedResponse at: 'token_type') equals: 'Bearer'.
	self assert: (expectedResponse at: 'id_token') equals: 'mock_id_token'.
]

{ #category : 'tests' }
GoogleAuthClientTest >> testGetCredentialsForServiceAccount [

	| mockAdcContents responseJsonString expectedResponse |
	mockAdcContents := Dictionary new
		                   at: 'type' put: 'service_account';
		                   at: 'client_email'
		                   put:
			                   'mock-service-account@project.iam.gserviceaccount.com';
		                   at: 'private_key_id' put: 'mock_key_id';
		                   at: 'private_key'
		                   put:
			                   '-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAnzyis1ZjfNB0bBgKFMSvvkTtwlvBsaJq7S5wA+kzeVOVpVWw
kWdVha4s38XM/pa/yr47av7+z3VTmvDRyAHcaT92whREFpLv9cj5lTeJSibyr/Mr
m/YtjCZVWgaOYIhwrXwKLqPr/11inWsAkfIytvHWTxZYEcXLgAXFuUuaS3uF9gEi
NQwzGTU1v0FqkqTBr4B8nW3HCN47XUu0t8Y0e+lf4s4OxQawWD79J9/5d3Ry0vbV
3Am1FtGJiJvOwRsIfVChDpYStTcHTCMqtvWbV6L11BWkpzGXSW4Hv43qa+GSYOD2
QU68Mb59oSk2OB+BtOLpJofmbGEGgvmwyCI9MwIDAQABAoIBACiARq2wkltjtcjs
kFvZ7w1JAORHbEufEO1Eu27zOIlqbgyAcAl7q+/1bip4Z/x1IVES84/yTaM8p0go
amMhvgry/mS8vNi1BN2SAZEnb/7xSxbflb70bX9RHLJqKnp5GZe2jexw+wyXlwaM
+bclUCrh9e1ltH7IvUrRrQnFJfh+is1fRon9Co9Li0GwoN0x0byrrngU8Ak3Y6D9
D8GjQA4Elm94ST3izJv8iCOLSDBmzsPsXfcCUZfmTfZ5DbUDMbMxRnSo3nQeoKGC
0Lj9FkWcfmLcpGlSXTO+Ww1L7EGq+PT3NtRae1FZPwjddQ1/4V905kyQFLamAA5Y
lSpE2wkCgYEAy1OPLQcZt4NQnQzPz2SBJqQN2P5u3vXl+zNVKP8w4eBv0vWuJJF+
hkGNnSxXQrTkvDOIUddSKOzHHgSg4nY6K02ecyT0PPm/UZvtRpWrnBjcEVtHEJNp
bU9pLD5iZ0J9sbzPU/LxPmuAP2Bs8JmTn6aFRspFrP7W0s1Nmk2jsm0CgYEAyH0X
+jpoqxj4efZfkUrg5GbSEhf+dZglf0tTOA5bVg8IYwtmNk/pniLG/zI7c+GlTc9B
BwfMr59EzBq/eFMI7+LgXaVUsM/sS4Ry+yeK6SJx/otIMWtDfqxsLD8CPMCRvecC
2Pip4uSgrl0MOebl9XKp57GoaUWRWRHqwV4Y6h8CgYAZhI4mh4qZtnhKjY4TKDjx
QYufXSdLAi9v3FxmvchDwOgn4L+PRVdMwDNms2bsL0m5uPn104EzM6w1vzz1zwKz
5pTpPI0OjgWN13Tq8+PKvm/4Ga2MjgOgPWQkslulO/oMcXbPwWC3hcRdr9tcQtn9
Imf9n2spL/6EDFId+Hp/7QKBgAqlWdiXsWckdE1Fn91/NGHsc8syKvjjk1onDcw0
NvVi5vcba9oGdElJX3e9mxqUKMrw7msJJv1MX8LWyMQC5L6YNYHDfbPF1q5L4i8j
8mRex97UVokJQRRA452V2vCO6S5ETgpnad36de3MUxHgCOX3qL382Qx9/THVmbma
3YfRAoGAUxL/Eu5yvMK8SAt/dJK6FedngcM3JEFNplmtLYVLWhkIlNRGDwkg3I5K
y18Ae9n7dHVueyslrb6weq7dTkYDi3iOYRW8HRkIQh06wEdbxt0shTzAJvvCQfrB
jg/3747WSsf/zBTcHihTRBdAv6OmdhV4/dD5YBfLAkLrd+mX7iE=
-----END RSA PRIVATE KEY-----';
		                   at: 'token_uri'
		                   put: 'https://oauth2.googleapis.com/token';
		                   yourself.

	mockCredentialsLoader
		on: #loadApplicationDefaultCredentials
		respond: mockAdcContents.


	responseJsonString := '{ "access_token": "mock_sa_access_token", "expires_in": 3600, "token_type": "Bearer" }'.

	mockHttpClient on: #httpPost:contents: respond: (ZnResponse new
			 statusLine: (ZnStatusLine new code: 200);
			 entity: (ZnEntity json: responseJsonString);
			 yourself).

	expectedResponse := client getCredentials
]

{ #category : 'tests' }
GoogleAuthClientTest >> testGetCredentialsForUnknownTypeRaisesError [

	| mockAdcContents |
	mockAdcContents := Dictionary new
		                   at: 'type' put: 'unsupported_type';
		                   yourself.

	mockCredentialsLoader
		on: #loadApplicationDefaultCredentials
		respond: mockAdcContents.

	self
		should: [ client getCredentials ]
		raise: Error
		description: 'Unsupported credential type'
]
