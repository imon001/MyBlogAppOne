//baseUrl
const baseUrl = 'http://192.169.0.112:5000/api/v1/user';

//const baseUrl = 'http://192.168.0.101:5000/api/v1/user';

//imageUrl
//const imageBaseUrl = 'http://192.168.0.101:5000/';
const imageBaseUrl = 'http://192.169.0.112:5000/';

//auth-apis
const loginApi = '$baseUrl/login';
const registerApi = '$baseUrl/register';
const checkResetPassApi = '$baseUrl/check-reset-pass';
const resetPassApi = '$baseUrl/reset-pass';

//home-apis
const allCategoryApi = '$baseUrl/category-all';
const getAllPostApi = '$baseUrl/post-all';
const likeUnlikeApi = '$baseUrl/like-unlike/';
const createPostApi = '$baseUrl/post-create';














// switch (response.statusCode) {
//         case 200:
         

//           break;

//         case 400:
//           apiResponse.error = jsonDecode(response.body)['message'];
//           break;

//         // case 400:
//         //   apiResponse.error = jsonDecode(response.body)['message'];

//         //   break;

//         case 401:
//           apiResponse.error = jsonDecode(response.body)['message'];
//           break;
//         // case 401:
//         //   apiResponse.error = jsonDecode(response.body)['message'];

//         //   break;

//         case 422:
//           final errors = jsonDecode(response.body)['errors'];
//           apiResponse.error = errors[errors.keys.elementAt(0)][0];
//           break;

//         // case 422:
//         //   final errors = jsonDecode(response.body)['errors'];
//         //   apiResponse.error = errors[errors.keys.elementAt(0)][0];

//         //   break;
//         case 403:
//           apiResponse.error = jsonDecode(response.body)['message'];
//           break;
//         // case 403:
//         //   apiResponse.error = jsonDecode(response.body)['message'];

//         //   break;

//         case 500:
//           apiResponse.error = SERVER_ERROR;
//           break;

//         // case 500:
//         //   apiResponse.error = SERVER_ERROR;

//         //   break;
//         default:
//           apiResponse.error = SOMETHING_WENT_WRONG;
//           break;
//         // default:
//         //   apiResponse.error = SOMETHING_WENT_WRONG;

//         //   break;
//       }