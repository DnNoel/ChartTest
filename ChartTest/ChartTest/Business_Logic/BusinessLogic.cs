using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using ChartTest.Models;
using Newtonsoft.Json;
using RestSharp;

namespace ChartTest.BusinessLogic
{
    public static class BusinessLogic
    {
        private static readonly string API_Url = System.Configuration.ConfigurationManager.AppSettings["ApiBaseUrl"];


        public static List<Book> getBookList(string access_token)
        {
            
            RestClient restClient = new RestClient(API_Url);
           
            var request = new RestRequest("/book", Method.GET);
            request.AddHeader("authorization", "Bearer " + access_token);
            request.RequestFormat = DataFormat.Json;

            var response = restClient.Execute<List<Book>>(request);

            if (response.Content == null || response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                return null;
            }
            else if (response.Content != null)
            {
                return response.Data.ToList<Book>();
            }
            else
            {
                return null;
            }

        }

        public static byte[] getImage(string ISBN)
        {
            RestClient restClient = new RestClient(API_Url);
            var request = new RestRequest("/book/" + ISBN + "/cover", Method.GET);
            request.RequestFormat = DataFormat.Json;

            var response = restClient.Execute<byte>(request);

            if (response.Content == null || response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                return null;
            }
            else if (response.Content != null)
            {
                return response.RawBytes;
            }
            else
            {
                return null;
            }
        }


        public static Book getBookbyId(int id)
        {
            RestClient restClient = new RestClient(API_Url);
            var request = new RestRequest("/book/" + id, Method.GET);
            request.RequestFormat = DataFormat.Json;

            var response = restClient.Execute<Book>(request);

            if (response.Content == null || response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                return null;
            }
            else if (response.Content != null)
            {
                return response.Data;
            }
            else
            {
                return null;
            }
        }


        public static User GetToken(string username, string password)
        {
            RestClient restClient = new RestClient(API_Url);


            string payload = "grant_type=password&" + "username=" + username + "&password=" + password;
            var request = new RestRequest("/Token", Method.POST);

            request.AddParameter("application/x-www-form-urlencoded", payload, ParameterType.RequestBody);
         //   request.RequestFormat = DataFormat.Json;

            var response = restClient.Execute<User>(request);

            if (response.Data == null || response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                return null;
            }
            else
            {
                return response.Data;
            }  
        }
    }
}