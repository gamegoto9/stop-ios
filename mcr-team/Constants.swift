//
//  constants.swift
//  mcr-team
//
//  Created by LIKIT on 2/2/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Foundation

let BASE_URL = "http://www.mcr-team.m-society.go.th/api/"

let URL_LOGIN = "\(BASE_URL)user/login"

let URL_FEEDS = "\(BASE_URL)emergency/user"

let URL_LOGIN_GOOGLE = "\(BASE_URL)user"

let URL_CREATE_EMERGENCY = "\(BASE_URL)emergency/create"

typealias DownloadComplete = () -> ()

var LANGUAGE: Int = 1

var ProfileImage: String = "default.png"
var ProfileImage2: String = "default.png"

var USER_TYPE_G: Int16!

var Form_ID: Int16!
var USER_NAME: String!
var EMAIL_: String!
var TEAM_ID: Int16!

var ProfileImage_UserChat: String = "default.png"

var ID_CHART: Int!

var Chat_status: Int!

var PUSH_NOTIFICATION: Int = 0

var Feed_data_post: Int = 0

var ForWort_ID: Int = 0

var ID_USER_DETAIL: Int = 0

var edit_profile_staff: Int = 0


var VerifyType: Int = 0



