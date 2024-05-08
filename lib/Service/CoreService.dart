import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:helpers/helpers.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:prospros/router/navrouter_constants.dart';
import 'package:prospros/util/app_util.dart';
import '../DeviceManger/ScreenConstants.dart';
import 'AppException.dart';
import 'Url.dart';

class CoreService {
  Future apiService({
    GlobalKey? key,
    header,
    body,
    bool multiPart = false,
    params,
    METHOD? method,
    SSL ssl = SSL.HTTPS,
    baseURL = Url.baseUrl,
    endpoint,
    filePath,
    String? fileKey,
    attachmentList,
    nextFileKey,
  }) async {
    var param;
    if (multiPart) {
      // param = {
      //   'uploadType': params.toString(),
      // };
      params = params;
    } else {
      param = params;
    }
    var endPoint = endpoint;
    var uri;
    if (ssl == SSL.HTTP) {
      uri = Uri.http(Uri.encodeFull(baseURL), Uri.encodeFull(endPoint), param);
    } else {
      uri = Uri.https(Uri.encodeFull(baseURL), Uri.encodeFull(endPoint), param);
    }

    print("uri =========");
    print(uri);

    Map<String, String> requestHeaders = method == METHOD.MULTIPART
        ? {
            'Content-type': 'multipart/form-data',
          }
        : {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          };
    if (header != null) {
      requestHeaders.addAll(header);
    }
    if (body != null && method != METHOD.MULTIPART) {
      body = json.encode(body);
    }
    debugPrint("Header :  $requestHeaders");
    debugPrint("Body :  $body");
    debugPrint("Params :  $params");
    debugPrint("URL :  $uri");
    debugPrint("Method :  $method");

    switch (method) {
      case METHOD.GET:
        {
          dynamic responseJson;
          try {
            final response = await http
                .get(uri, headers: requestHeaders)
                .timeout(const Duration(minutes: 2));
            responseJson = _returnResponse(response);
          } catch (error) {
            Get.back();
          }
          return responseJson;
        }

      case METHOD.PUT:
        {
          dynamic responseJson;
          try {
            final response = await http
                .put(uri, headers: requestHeaders, body: body)
                .timeout(const Duration(minutes: 2));
            responseJson = _returnResponse(response);
          } catch (error) {
            Get.back();
          }
          return responseJson;
        }

      case METHOD.DELETE:
        {
          dynamic responseJson;
          try {
            final response = await http
                .delete(uri, headers: requestHeaders)
                .timeout(const Duration(minutes: 2));
            responseJson = _returnResponse(response);
          } catch (error) {
            Get.back();
          }
          return responseJson;
        }

      case METHOD.PATCH:
        {
          dynamic responseJson;
          try {
            final response = await http
                .patch(uri, headers: requestHeaders, body: body)
                .timeout(const Duration(minutes: 2));
            responseJson = _returnResponse(response);
          } catch (error) {
            Get.back();
          }
          return responseJson;
        }

      case METHOD.POST:
        {
          dynamic responseJson;
          try {
            /* http.post(uri, headers: requestHeaders, body: body).then((value){
                var data=value;
                print(data);
              var   responseJson = _returnResponse(data,loader);
                print(data);
              }).timeout(Duration(minutes: 2));*/

            final response = await http
                .post(uri, headers: requestHeaders, body: body)
                .timeout(const Duration(minutes: 2));

            responseJson = _returnResponse(response);
          } on UnauthorisedException catch (err) {
            var data = json.decode(err.message);
            Apputil.closeProgressDialouge();
            if (Get.currentRoute != login) {
              Get.showSnackbar(GetSnackBar(
                snackPosition: SnackPosition.BOTTOM,
                message: "User is inactive",
                duration: Duration(seconds: 2),
                margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
              ));
            }
            await Future.delayed(Duration(milliseconds: 500));
            if (Get.currentRoute != login) {
              Apputil.closeProgressDialouge();
              Get.offAllNamed(login);
              return null;
            }
            if (Get.currentRoute == login) {
              return data;
            } else {
              return null;
            }
          } on AppException catch (err) {
            var data = json.decode(err.message);

            ///Disable error message dialouge; we need to handle this at api service calling place
            // printRed(data['message'] ?? "Nothing");
            // Future.delayed(Duration.zero, () {
            //   Get.showSnackbar(GetSnackBar(
            //     snackPosition: SnackPosition.BOTTOM,
            //     // message: err.message,
            //     message: data['message'] ?? "Something went wrong",
            //     duration: Duration(seconds: 2),
            //     margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            //   ));
            // });

            // throw UnknownException("Try again or revisit the screen.");
            return data;
          } catch (error) {
            //Get.back();
            printGreen(responseJson);
            Get.showSnackbar(GetSnackBar(
              snackPosition: SnackPosition.BOTTOM,
              message: error.toString(),
              duration: Duration(seconds: 2),
              margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
            ));
            debugPrint("Catch block:  $error");
            // throw UnknownException("Try again or revisit the screen.");
          }
          return responseJson;
        }

      case METHOD.MULTIPART:
        {
          dynamic responseJson;

          try {
            var request = http.MultipartRequest(
              'POST',
              uri,
            );

            if (header != null) {
              request.headers.addAll(header);
            }
            if (body != null) {
              log(body.toString());

              Map<String, String> a = new Map<String, String>();

              body.forEach((key, value) {
                a[key] = value.toString();
              });

              request.fields.addAll(a);
            }

            if (filePath is RxList<File>) {
              List<http.MultipartFile> data = <http.MultipartFile>[];
              for (int i = 0; i < filePath.length; i++) {
                final mimeTypeData =
                    lookupMimeType(filePath[i].path, headerBytes: [0xFF, 0xD8])!
                        .split('/');
                data.add(await http.MultipartFile.fromPath(
                    '$fileKey[$i]', filePath[i].path,
                    contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
              }
              request.files.addAll(data);
            } else {
              //request.fields.addAll(body);
              final mimeTypeData = lookupMimeType(filePath.toString(),
                      headerBytes: [0xFF, 0xD8])!
                  .split('/');
              request.files.add(await http.MultipartFile.fromPath(
                  fileKey!.toString(), filePath.toString(),
                  contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
              debugPrint("Request : $request");
            }
            if (attachmentList != null && nextFileKey != null) {
              if (attachmentList is RxList<File>) {
                List<http.MultipartFile> data = <http.MultipartFile>[];
                for (int i = 0; i < filePath.length; i++) {
                  final mimeTypeData = lookupMimeType(filePath[i].path,
                          headerBytes: [0xFF, 0xD8])!
                      .split('/');
                  data.add(await http.MultipartFile.fromPath(
                      '$nextFileKey[$i]', attachmentList[i].path,
                      contentType:
                          MediaType(mimeTypeData[0], mimeTypeData[1])));
                }
                request.files.addAll(data);
              } else {
                final mimeTypeData =
                    lookupMimeType(filePath, headerBytes: [0xFF, 0xD8])!
                        .split('/');
                request.files.add(await http.MultipartFile.fromPath(
                    nextFileKey, attachmentList,
                    contentType: MediaType(mimeTypeData[0], mimeTypeData[1])));
                debugPrint("Request : $request");
              }
            }
            final http.StreamedResponse response = await request.send();
            debugPrint(response.reasonPhrase);
            responseJson = await http.Response.fromStream(response);
            responseJson = _returnResponse(responseJson);
          } catch (error) {
            debugPrint(error.toString());
            Get.back();
          }

          print("======== multipart response");
          log(responseJson.toString());
          return responseJson;
        }

      default:
        {
          dynamic responseJson;
          try {
            Get.dialog(
                const Center(
                    child: CircularProgressIndicator(
                  color: Color(0xFFFF6F08),
                )),
                barrierDismissible: false);
            final response =
                await http.post(uri, headers: requestHeaders, body: body);
            responseJson = _returnResponse(response);
          } catch (error) {
            Get.back();
          }
          return responseJson;
        }
    }
  }

  dynamic _returnResponse(http.Response response) {
    print("===Response");
    log(response.body);
    if (response.body.contains("Unauthenticated")) {
      //user is unauthenticated(He might be deleted from db)

      Apputil.logoutStoredKey();

      if (Get.currentRoute != login) {
        Get.offAllNamed(login);
      }
    }

    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(
            const Utf8Decoder().convert(response.body.toString().codeUnits));
        debugPrint("Result : $responseJson");
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
        throw UnauthorisedException(response.body.toString());
      case 402:
        throw UnauthorisedException(response.body.toString());
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(response.body);
    }
  }

  Future<bool> networkCheck() async {
    try {
      final result = await InternetAddress.lookup('${Url.baseUrl}');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } on SocketException catch (_) {
      return true;
    }
  }

  Widget normalLoader() {
    return Center(
        child: Container(
            height: ScreenConstant.sizeXXL,
            width: ScreenConstant.sizeXXL,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.white,
                ),
                borderRadius:
                    const BorderRadius.all(const Radius.circular(40))),
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 1.5,
              ),
            )));
  }
}

enum METHOD {
  GET,
  PUT,
  POST,
  DELETE,
  PATCH,
  MULTIPART,
}

enum SSL {
  HTTP,
  HTTPS,
}
