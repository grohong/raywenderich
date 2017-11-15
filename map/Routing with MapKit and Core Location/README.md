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
<br>


### CoreLocation을 사용하여 사용자 항목 처리

#### 텍스트 필드값에 쓴 장소 찾기
```swift
@IBAction func addressEntered(sender: UIButton) {
 view.endEditing(true)
 // 1
 let currentTextField = locationTuples[sender.tag-1].textField
 // 2
 CLGeocoder().geocodeAddressString((currentTextField?.text!)!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
     if let placemarks = placemarks {

     } else {

     }
 })
}
```
**geocodeAddressString**
- 지리 좌표와 장소 명을 변환하기위한 인터페이스입니다.



1. mainView의 textField중 button이 눌린 옆에 textField를 가지고 온다.
2. CLGeocoder의 geocodeAddressString를 이용하여 찾을려는 정보를 가지고와서 completionHandler를 이용해 처리한다. (유사장소가 있을때와 없을때)
<br>

#### 유사장소를 tableView로 나타내기

```swift
func showAddressTable(addresses: [String]) {
        let addressTableView = AddressTableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        addressTableView.addresses = addresses
        addressTableView.delegate = addressTableView
        addressTableView.dataSource = addressTableView
        view.addSubview(addressTableView)
    }
```

- viewController에 table를 보여줄 함수를 구현합니다.
  - addressTableView 클래스에 delegate를 정의해고 선언한다.
  - addressTableView에 들어갈 정보들(addresses)을 보낸다.
<br>

#### geocodeAddressString의 값 처리 - table로 보내기!

```swift
@IBAction func addressEntered(sender: UIButton) {
    view.endEditing(true)

    let currentTextField = locationTuples[sender.tag-1].textField

    CLGeocoder().geocodeAddressString((currentTextField?.text!)!, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) -> Void in
        if let placemarks = placemarks {
            var addresses = [String]()
            for placemark in placemarks {
                addresses.append(self.formatAddressFromPlacemark(placemark: placemark))
            }
            self.showAddressTable(addresses: addresses)
        } else {
            self.showAlert(alertString: "Address not found.")
        }
    })
  }
```

- completionHandler에서 placemark(검색 위치)에 리턴값이 있으면 addresses변수에 주소를 formatAddressFromPlacemark로 String 변환하여 추가 합니다.
- showAddressTable에 주소들을 넘겨 줍니다.
- 주소가 없을 경우 "Address not found" 알람을 띄웁니다.


#### tableView에서 원하는 주소를 클릭했을때 event 넣기

*showAddressTable에 addressTableView에서 사용될 변수를 더 설정해 줍니다.*

```swift
func showAddressTable(addresses: [String], textField: UITextField, placemarks: [CLPlacemark], sender: UIButton) {
        let addressTableView = AddressTableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        addressTableView.addresses = addresses
        addressTableView.currentTextField = textField
        addressTableView.placemarkArray = placemarks
        addressTableView.mainViewController = self
        addressTableView.sender = sender
        addressTableView.delegate = addressTableView
        addressTableView.dataSource = addressTableView
        view.addSubview(addressTableView)
    }
  ```
- 주소가 들어갈 textField를 설정합니다.
- 주소 정보가 있는 plackemakrs를 설정합니다.
- 버튼 정보가 있는 sender를 설정합니다.


*completionHandler에서 함수에 추가된 정보를 넣어줍니다.*
```swift
self.showAddressTable(addresses, textField: currentTextField,
    placemarks: placemarks, sender: sender)
```
<br>  



*addressTableView에 tableView:didSelectRowAtIndexPath: 함수에 event 설정을 해줍니다.*

```swift
func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if addresses.count > indexPath.row {
            currentTextField.text = addresses[indexPath.row]
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: (placemarkArray[indexPath.row].location?.coordinate)!, addressDictionary: placemarkArray[indexPath.row].addressDictionary as! [String : AnyObject]))

            mainViewController.locationTuples[currentTextField.tag-1].mapItem = mapItem

            sender.isSelected = true
        }

    removeFromSuperview()
  }
```

- ```addresses.count > indexPath.row``` 선택한 셀이 주소의 갯수안에 있을때(선택될 셀의 정의)
- mainView에서 받은 textField에 주소를 넣습니다.
- mainViewController에 locationTuples에 해당 정보를 추가합니다.
- button에 완료표시를 합니다.
<br><br>


*textField:shouldChangeCharactersInRange:replacementString: 안에 문자 입력시 재설정*

```swift
func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        enterButtonArray.filter{$0.tag == textField.tag}.first!.isSelected = false
        locationTuples[textField.tag-1].mapItem = nil

        return true
  }
```
- textFieldDelate 에서 textField:shouldChangeCharactersInRange:replacementString:를 통해 textField에서 문자열이 바뀌었을때 이벤트를 설정합니다.
- textField의 태그와 같은 button태그의 selected를 false로 변경
- locationTuples의 해당 mapItem을 nil로 설정합니다.
<br><br>

*swapFields 이벤트 설정*

```swift
@IBAction func swapFields(sender: AnyObject) {
    swap(&destinationField1.text, &destinationField2.text)
    swap(&locationTuples[1].mapItem, &locationTuples[2].mapItem)
    swap(&self.enterButtonArray.filter{$0.tag == 2}.first!.isSelected, &self.enterButtonArray.filter{$0.tag == 3}.first!.isSelected)
  }
```
- swap버튼을 눌렀을때 textField, locationTuples, button상태를 바꿀수 있게 하였다.


#### DirectionsViewController segue 설정

*데이터가 없을때 넘어가지 못하게 함*

```swift
override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if locationTuples[0].mapItem == nil || (locationTuples[1].mapItem == nil && locationTuples[1].mapItem == nil) {
            print("Please enter a valid starting point and at least one destination.")
            return false
        } else {
            return true
        }
    }
```

- shouldPerformSegue를 override하여 segue가 될떄 안될때를 구분한다.
  - locationTuples의 정보가 조건을 충족할때 segue가 동작
<br><br>


*DirectionsViewController의 locationsArray 설정*

```swift
var locationsArray: [(textField: UITextField?, mapItem: MKMapItem?)] {
    var filtered = locationTuples.filter({$0.mapItem != nil})
    filtered += [filtered.first!]
    return filtered
   }
```
<br><br>

*prepareForSegue:sender:를 통해 DirectionsViewController에 값 넘기기*

```swift
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var directionsViewController = segue.destination as! DirectionsViewController
        directionsViewController.locationArray = locationsArray
    }
```
- 
