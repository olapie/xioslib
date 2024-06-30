//
//  File.swift
//  
//
//  Created by tan on 2024-06-30.
//


import UIKit
import Photos
import PhotosUI

enum ImportFileType: Identifiable {
    var id: Self {
        return self
    }
    case ImportPhoto
    case ImportVideo
    case ImportDocument
    
    func iconName() -> String {
        switch self {
        case .ImportPhoto: return "photo.on.rectangle.angled"
        case .ImportVideo: return "arrow.down.left.video"
        case .ImportDocument: return "doc"
        }
    }
    
    func icon() -> UIImage {
        return UIImage(systemName: iconName())!
    }
    
    func title() -> String {
        switch self {
        case .ImportPhoto: return Translate("ImportAlbumPhotos")
        case .ImportVideo: return Translate("ImportAlbumVideos")
        case .ImportDocument: return Translate("ImportDocuments")
        }
    }
}

func showImportFileMenu(_ types: [ImportFileType], sourceView: UIView?,  action: @escaping (ImportFileType)->()) {
    let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    types.forEach { type in
        let alertAction = UIAlertAction(title: type.title(), style: .default) { (_) in
            action(type)
            
        }
        alertAction.setSystemImageName(type.iconName())
        sheet.addAction(alertAction)
    }
    if let ppc = sheet.popoverPresentationController {
        ppc.sourceView = sourceView
        ppc.sourceRect = sourceView!.bounds
    }
    let cancel = UIAlertAction(title: Translate("Cancel"), style: .cancel) { (_) in }
    sheet.addAction(cancel)

    let viewController = getKeywindow()!.rootViewController!
    viewController.present(sheet, animated: true, completion: nil)
}


@available(iOS 15.0, *)
func importPhotos(_ handler: (_ data:Data) -> ()) {
    var conf = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
    conf.selectionLimit = 9
    conf.filter = .any(of: [.images, .livePhotos, .screenshots]) //.livePhotos,
    conf.preferredAssetRepresentationMode = .current // very important: improve loadFileRepresentation speed
    let picker = PHPickerViewController(configuration: conf)
//    picker.delegate = self
    
//    parent?.present(picker, animated: true, completion: nil)
}


protocol PickerResultHandler {
    func handlePhoto(_ thumbnail: UIImage, data: Data)
    func handleVideo(_ thumbnail: UIImage, filepath: String)
}

class PickerViewControllerDelegate: PHPickerViewControllerDelegate {
    var handler: PickerResultHandler
    
    init(_ handler: PickerResultHandler) {
        self.handler = handler
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        ProgressHUD.showError(Translate("Processing"))
//        DispatchQueue.global().async {
//            var assetIdentifiers = [String]()
//            let group = DispatchGroup()
//            for res in results {
//                let p = res.itemProvider
//                if p.canLoadObject(ofClass: UIImage.self) {
//                    group.enter()
//                    p.loadObject(ofClass: UIImage.self) { (image, error) in
//                        defer { group.leave() }
//                        guard let img = (image as? UIImage) else {
//                            return
//                        }
//                        guard let data = img.jpegData(compressionQuality: 1.0) else {
//                            return
//                        }
//                        let thumbnail = img.scalePreservingAspectRatio(targetSize: CGSize(width: 360, height: 360))
//                        if let id = res.assetIdentifier {
//                            assetIdentifiers.append(id)
//                        }
//                        self.handler.handlePhoto(img, data: data)
//                    }
//                } else if p.canLoadObject(ofClass: PHLivePhoto.self) {
//                    group.enter()
//                    p.loadObject(ofClass: PHLivePhoto.self) { (livePhoto, err) in
//                        defer { group.leave() }
//                        if let er = err {
//                            print(er.localizedDescription)
//                            return
//                        }
//                        guard let lp = livePhoto as? PHLivePhoto else {
//                            return
//                        }
//
//                        // TODO:
//                    }
//                } else if p.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
//                    group.enter()
//                    p.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { (url, err) in
//                        defer { group.leave() }
//                        if let er = err {
//                            Toast.error(er.localizedDescription)
//                            return
//                        }
//                        guard let file = box.importFile(self.folderID, filename: url!.path)?.file else {
//                            return
//                        }
//                        list.append(file)
//                        let asset = AVAsset(url: url!)
//                        file.setDuration(Int(asset.duration.seconds))
//                        if let err = box.saveFileTree() {
//                            print(err.error())
//                        } else {
//                            if let id = res.assetIdentifier {
//                                assetIdentifiers.append(id)
//                                self.updateItem(file, assetIdentifier: id)
//                            }
//                        }
//                        let generator = AVAssetImageGenerator(asset: asset)
//                        generator.appliesPreferredTrackTransform = true
//                        let t = CMTimeMake(value: 0, timescale: 1)
//                        do {
//                            let cgThumb = try generator.copyCGImage(at: t, actualTime: nil)
//                            if let data = UIImage(cgImage: cgThumb).jpegData(compressionQuality: 1.0) {
//                                box.saveThumbnail(file.id_(), data: data)
//                            }
//                        } catch {
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//            }
//
//            group.notify(queue: .main) {
//                self.addFiles(list)
//                Toast.dismiss()
//                if !assetIdentifiers.isEmpty {
//                    self.deleteFromAlbum(assetIdentifiers)
//                }
//            }
//        }
    }
}
