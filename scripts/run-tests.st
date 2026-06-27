"Run all google-cloud-smalltalk tests and print results to the Transcript.
 Paste into the Playground and Ctrl+D, or run headlessly:
   ./pharo Pharo.image test 'Google.*'
 Tests are offline (no credentials / no network)."
| suite result |
suite := TestSuite new.
(TestCase allSubclasses
	select: [ :c | (c category ifNil: [ '' ]) beginsWith: 'Google' ])
	do: [ :c | c suite tests do: [ :t | suite addTest: t ] ].
result := suite run.
Transcript showCr: '=== google-cloud-smalltalk Test Results ==='.
Transcript showCr: 'Run:    ' , suite tests size printString.
Transcript showCr: 'Passed: ' , result passedCount printString.
Transcript showCr: 'Failed: ' , result failures size printString.
Transcript showCr: 'Errors: ' , result errors size printString.
result failures do: [ :f | Transcript showCr: '  FAIL: ' , f printString ].
result errors do: [ :e | Transcript showCr: '  ERR:  ' , e printString ].
