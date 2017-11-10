### CoreLocation 으로 현재 주소 얻기


```swift
override func viewDidLoad() {
    super.viewDidLoad()
    originalTopMargin = topMarginConstraint.constant

  }
```

```swift
//1
let locationManager = CLLocationManager()

override func viewDidLoad() {
  super.viewDidLoad()
  originalTopMargin = topMarginConstraint.constant
  //2
  locationManager.delegate = self
  locationManager.requestWhenInUseAuthorization()
  //3
  if CLLocationManager.locationServicesEnabled() {
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    locationManager.requestLocation()
  }
}
```

1. CLLocationManager을 전역변수로 설정
2. CLLocationManager의 delegate을 설정, 사용자에게 명시적으로 권한 물어보기
3. CLLocationManager로 현재위치의 정확도를 지정한다음, 현재위치를 요청 받습니다.


  하지만 앱을 실행하게 되면 **"The app's Info.plist must contain an NSLocationWhenInUseUsageDescription key with a string value explaining to the user how the app uses this data"** 오류가 나게 될것입니다.
