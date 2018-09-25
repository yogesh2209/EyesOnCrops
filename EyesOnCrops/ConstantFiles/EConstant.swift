//
//  EConstant.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/4/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import Foundation

/* URLs */
let MAIN_URL                                            = "https://eoe.dynu.net/yogesh/"
let POST_CREDENTIALS                                    = "credentials.php"
let POST_GET_DATA                                       = "get_data.php"


/* ------------ SEGUE IDENTIFIERS ---------------- */

let LOGINSCREEN_SEGUE_VC                                = "mainToLoginSegueVC"
let LOGINTOEMAIL_SEGUE_VC                               = "loginToLoginEmailSegueVC"
let REGISTER_1_SEGUE_VC                                 = "mainToRegisterOneSegueVC"
let REGISTER_1_TO_2_SEGUE_VC                            = "register1To2SegueVC"
let REGISTER_2_TO_3_SEGUE_VC                            = "register2To3SegueVC"
let REGISTER_3_TO_PSWD_SETUP_SEGUE_VC                   = "registerThreeToPswdSetupSegueVC"
let REGISTER_PSWD_SETUP_TO_4_SEGUE_VC                   = "pswdSetupToRegisterFourSegueVC"
let LOGIN_TO_HOME_SEGUE_VC                              = "loginToHomeSegueVC"
let SOCIAL_LOGIN_TO_REG_SEGUE_VC                        = "socialLoginToRegister4thSegueVC"
let SOCIAL_LOGIN_TO_HOME_SEGUE_VC                       = "socialLoginToHomeSegueVC"
let LOGOUT_SEGUE_VC                                     = "logoutSegueVC"
let ABOUT_SEGUE_VC                                      = "sidMenuToAboutSegueVC"
let HELP_SEGUE_VC                                       = "sidMenuToHelpSegueVC"
let SIDEMENU_TO_HOME_SEGUE_VC                           = "sideMenuToHomeSegueVC"
let CHANGE_PASS_SEGUE_VC                                = "changePasswordSegueVC"
let PASSEORD_RECOVERY_1_SEGUE_VC                        = "passwordRecovery1SegueVC"
let HOME_TO_FILTER_CATEGORY_LIST_SEGUE_VC               = "homeToFilterCategoryListSegueVC"
let CATEGORY_LIST_TO_LEVEL_LIST_SEGUE_VC                = "categoryListToLevelListSegueVC"
let PSWD_RECOVERY_EMAIL_TO_DOB_SEGUE_VC                 = "passwordRecovery2SegueVC"
let PSWD_RECOVERY_DOB_TO_FINAL_SEGUE_VC                 = "passwordRecovery3SegueVC"
let PURPOSE_TO_HOME_SEGUE_VC                            = "registerToHomeSegueVC"
let FILTER_TO_YEAR_LIST_SEGUE_VC                        = "filterOptionsToYearsListSegueVC"
let YEAR_LIST_TO_DATES_SEGUE_VC                         = "yearListToDatesListSegueVC"
let FILTER_TO_COLOR_LIST_SEGUE_VC                       = "filterToColorListSegueVC"

/* ---------- STORYBOARD IDs -------------------- */
let TERMS_PRIVACY_STORYBOARD_ID                         = "termsPrivacyStoryboardId"

/* ---------- TABLEVIEW CELLS --------------------- */

let SIDE_MENU_OPTIONS_CUSTOM_CELL                       = "sideMenuOptionCustomCell"
let SIDE_MENU_SPACING_CUSTOM_CELL                       = "sideMenuSpacingCustomCell"
let SIDE_MENU_PROFILE_CUSTOM_CELL                       = "sideMenuProfileCustomCell"
let FILTER_CATEGORY_LIST_OPTION_CUSTOM_CELL             = "filterCategoryOptionCustomCell"
let FILTER_CATEGORY_LIST_SPACING_CUSTOM_CELL            = "filterCategoryPlainSpaceCustomCell"
let FILTER_CATEGORY_SATELLITE_TYPE_CUSTOM_CELL          = "filterCategorySatelliteTypeCustomCell"
let FILTER_LEVEL_LIST_OPTION_CUSTOM_CELL                = "levelListOptionCustomCell"
let FILTER_LEVEL_LIST_PLAIN_SPACE_CUSTOM_CELL           = "levelListPlainSpaceCustomCell"
let FILTER_CATEGORY_MAP_TYPE_CUSTOM_CELL                = "filterCategoryMapTypeCustomCell"
let YEAR_LIST_CUSTOM_CELL                               = "yearListCustomCell"
let DATES_LIST_CUSTOM_CELL                              = "datesListCustomCell"
let FILTER_CATEGORY_DATA_TYPE_CUSTOM_CELL               = "filterCategoryDataTypeCustomCell"
let FILTER_COLOR_SCHEME_OPTION_CUSTOM_CELL              = "eFilterColorSchemeOptionListCustomCell"
let FILTER_COLOR_PLAIN_SPACE_CUSTOM_CELL                = "eFilterColorSchemePlainSpaceCustomCell"


/* -------- STATIC ARRAYS / DATA ---------------- */

let FilterCategoryArray = ["Data","Map","Layer","Year : Date", "Level", "Color Scheme"]
let LevelListArray = ["Admin Level 0","Admin Level 1","Admin Level 2"]
let categoryDetailsArray = [".",".",".","Select year and date", "Select Admin Level", "Select color scheme for data"]


/* -------- ALERT MESSAGE STRINGS ---------------- */

let ALERT_TITLE                                         = "Alert"
let ALERT_ERROR_TITLE                                   = "Error"
let SOMETHING_WENT_WRONG_ERROR                          = "Something went wrong, please try again later"
let EMPTY_FIELD_ERROR                                   = "Required fields cannot be empty!"
let INVALID_PHONE_ERROR                                 = "Please enter a valid phone!"
let INVALID_EMAIL_ERROR                                 = "Please enter a valid email!"
let EMAIL_PHONE_EMPTY_ERROR                             = "Email and Phone cannot be empty!"
let LOCATION_NOT_PICK_ERROR                             = "Either pick current location or enter location manually!"
let LOCATION_SERVICES_DISABLED_ERROR                    = "Location services not enabled!"
let LOCATION_FAILED_GET_ERROR                           = "Failed to Get Your Location! Try again!"
let INVALID_LOCATION_ENTERED_ERROR                      = "Please enter a valid location!"
let DISAGREE_CONDITIONS_TERMS_USE_ERROR                 = "You must agree to terms and conditions!"
let MISSING_PURPOSE_APP_USE_ERROR                       = "Please type purpose of using the app"
let EMPTY_PASSWORD_ERROR                                = "Password cannot be empty"
let PSWD_CONFIRM_PSWD_NOT_MATCHED_ERROR                 = "Password does not match"
let INVALID_PASSWORD_ERROR                              = "Please must be greater than 6 characters"
let USER_ALREADY_REGISTERED                             = "User already exist!"
let INVALID_CREDENTIALS_LOGIN                           = "Please check your credentials"
let EMPTY_DATE_OF_BIRTH_ERROR                           = "Year of birth cannot be empty"
let DATE_OF_BIRTH_MISMATCH_ERROR                        = "Year of Birth does not match"
let NO_DATA_AVAILABLE                                   = "No data available for"
let NO_YEAR_FOUND                                       = "No year found"
let NO_DATES_FOR_YEAR_FOUND                             = "No dates for year found"


/* -------- PLACEHOLDER STRINGS ---------------- */

let LOCATION_NOT_PICKED_TEXTVIEW                        = "You haven't picked any location yet! Enter it!"
let LOCATION_TEXTVIEW                                   = "Enter your location here"


/* ------- ACTION_FOR - WEB SERVICES URLs --------- */
let ACTION_FOR_REGISTER                                 = "register_user"
let ACTION_FOR_GET_USER_WHOLE_DATA                      = "user_data"
let ACTION_FOR_LOGIN                                    = "login"
let ACTION_FOR_LOGIN_SOCIAL                             = "login_social"
let ACTION_UPDATE_USER_STATUS                           = "update_user_status"
let ACTION_PSWD_RECOVERY_USER_DATA                      = "pswd_recovery_fetch_user_data"
let ACTION_FOR_UPDATE_PASSWORD                          = "update_user_password"
let ACTION_FOR_YEARS_LIST                               = "years_list"
let ACTION_FOR_DATES_IN_YEAR                            = "dates_in_year"
let ACTION_FOR_JSON_DATA                                = "ndvi_data"



