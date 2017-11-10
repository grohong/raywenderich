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

  이는 ```Info.plist``` 에 들어가서

  ```xml
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>This app needs your current location</string>
  ```
  등록하여 권한을 등록 해야 됩니다.

  ![권한설정](/images/권한설정.jpeg)

  그럼 이런식으로 해당웹의 위치 접근 여부를 물어봅니다.

<br>
### CoreLocation을 사용하여 사용자 항목 처리

**CLLocationManagerDelegate** 의 <br>
**locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]** 함수(장소가 없데이트 됐을때) 코드를 추가합니다.


```swift
  CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
              }
      })
  }
```

**CLGeocoder**
- 지리 좌표와 장소 명을 변환하기위한 인터페이스

**CLPlacemark**
- 장소 이름, 주소 및 기타 관련 정보를 포함하는 지리적 좌표에 대한 사용자 친화적 인 설명입니다.

```CLGeocoder().reverseGeocodeLocation``` 을 이용하여 ```CLLocationManager```를 통해 가저온 location(여러개를 가지고 올수 있지만 제일 마지막에 가지고온 location)을 이용하여 현재 장소를 가지고 온다.
<br>

viewDidLoad를 위에 location정보를 넣을 튜블 리스트를 만든다.
```swift
  var locationTuples: [(textField: UITextField!, mapItem: MKMapItem?)]!
```
<br>

viewDidLoad에서 해당 튜블의 textField를 정의하고 초기화 시킨다.
```swift
  locationTuples = [(sourceField, nil), (destinationField1, nil), (destinationField2, nil)]
```
<br>

placemark에서 주소 정보로 전환해주는 간단한 함수를 하나 만들어 둔다
```swift
func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
```
<br>

```completionHandler``` 안에서 가지고온 위치정보를 textField에 넣는다.
```swift
  self.sourceField.text = self.formatAddressFromPlacemark(placemark: placemark)
```
<br>

textField옆에 정보가 들어갔다는 표시를 해둔다.
```swift
  self.enterButtonArray.filter{$0.tag == 1}.first!.isSelected = true
```
