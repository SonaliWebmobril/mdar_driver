import UIKit
import Flutter
import Firebase
import GoogleMaps
import flutter_callkit_incoming
import CallKit
import AVFAudio
import PushKit

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate, CallkitIncomingAppDelegate {
  
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GMSServices.provideAPIKey("AIzaSyAVtBD-U5-jXU2L4zCdrSuaWxDlZyvsIv4")
      GeneratedPluginRegistrant.register(with: self)
      //Setup VOIP
      let mainQueue = DispatchQueue.main
      let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
      voipRegistry.delegate = self
      voipRegistry.desiredPushTypes = [PKPushType.voIP]
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
        
        // Handle updated push credentials
        func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        }
        
        func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
            print("didInvalidatePushTokenFor")
            SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
        }
        
        // Handle incoming pushes
        func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        }
        
        
        // Func Call api for Accept
        func onAccept(_ call: Call, _ action: CXAnswerCallAction) {
        }
        
        // Func Call API for Decline
        func onDecline(_ call: Call, _ action: CXEndCallAction) {
        }
        
        // Func Call API for End
        func onEnd(_ call: Call, _ action: CXEndCallAction) {
        }
        
        // Func Call API for TimeOut
        func onTimeOut(_ call: Call) {
        }
        
        // Func Callback Toggle Audio Session
        func didActivateAudioSession(_ audioSession: AVAudioSession) {
        }
        
        // Func Callback Toggle Audio Session
        func didDeactivateAudioSession(_ audioSession: AVAudioSession) {
        }
        
        func performRequest(parameters: [String: Any], completion: @escaping (Result<Any, Error>) -> Void) {
        }
        
}
