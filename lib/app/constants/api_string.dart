//baseUrl
//const baseUrl = 'http://192.169.0.112:3000/api/v1/user';

const baseUrl = 'http://192.168.0.101:3000/api/v1/user';

//imageUrl
const imageBaseUrl = 'http://192.168.0.101:3000/';
//const imageBaseUrl = 'http://192.169.0.112:3000/';

//auth-apis
const loginApi = '$baseUrl/login';
const registerApi = '$baseUrl/register';
const checkResetPassApi = '$baseUrl/check-reset-pass';
const resetPassApi = '$baseUrl/reset-pass';

//home-apis
const allCategoryApi = '$baseUrl/category-all';
const getAllPostApi = '$baseUrl/post-all';
const likeUnlikeApi = '$baseUrl/like-unlike/';
const deletePostApi = '$baseUrl/delete-post/';
const getdeletedPostApi = '$baseUrl/deleted-posts';
const deletePostPermanentApi = '$baseUrl/delete-post-permanent/';
const savePostApi = '$baseUrl/save-post/';
const getSavedPostApi = '$baseUrl/get-saved-posts';
const removedSavedPostApi = '$baseUrl/remove-saved-post/';
const restorePostApi = '$baseUrl/restore-post/';
const getCategoryPostApi = '$baseUrl/get-posts-by-category/';
const searchOptionApi = '$baseUrl/search-posts/';
const createPostApi = '$baseUrl/post-create';
const editPostApi = '$baseUrl/post-edit';

//comment
const getCommentApi = '$baseUrl/get-comments/';
const createCommentApi = '$baseUrl/create-comment';
const deleteCommentApi = '$baseUrl/delete-comment/';

//replies
const createReplyApi = '$baseUrl/create-reply';
const deleteReplyApi = '$baseUrl/delete-reply/';
const getReplyApi = '$baseUrl/get-replies/';

//profile
const userDataApi = baseUrl;
const getMyPostApi = '$baseUrl/my-posts';
const updatePasswordApi = '$baseUrl/update-pass';
const updateProfileApi = '$baseUrl/update-profile';
const updateProfilePhotoApi = '$baseUrl/update-profile-photo';







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