import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseC {
  SupabaseC(){
    Supabase.initialize(url: 'https://vyyklhaaerlokvoslcar.supabase.co', anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ5eWtsaGFhZXJsb2t2b3NsY2FyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDgwMjcwNjUsImV4cCI6MjAyMzYwMzA2NX0.p_81H973ZvrPBLVkTFJhWeim8RtovyP4ADSqExZEkkA");
  }

  // Method to add data to a specified table
  Future<void> addData(String table, Map<String, dynamic> data) async {
    var client = Supabase.instance.client;
    var response = await client.from(table).insert(data);
    print(response);
  }

  // Method to update data in a specified table based on multiple conditions
  Future<void> updateData(String table, Map<String, dynamic> data, createdAt, {required String conditionColumn, String? conditionValue}) async {
    var client = Supabase.instance.client;
    var response = await client
        .from(table)
        .update({'trip_details': data})
        .eq('trip_details->$conditionColumn', conditionValue!)
        .eq('created_at', createdAt);
       

    print(response);
  }

  // Method to get data from a specified table based on a unique identifier
  Future<PostgrestList> getData(String table, String column, dynamic value) async {
    var client = Supabase.instance.client;
    var response = await client.from(table).select("*").eq(column, value);
    return response as PostgrestList;
  }

  // Example of listening to changes in a table (you can adjust as needed)
 
}
