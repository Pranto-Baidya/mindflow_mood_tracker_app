
class QuoteModel{
  final String uid;
  final String content;
  final String author;
  final int length;

  QuoteModel({required this.uid,required this.content, required this.author, required this.length});


  //Api model
  factory QuoteModel.fromJson(Map<String,dynamic> json,String uid){
    return QuoteModel(
        uid: uid,
        content: json['content'],
        author: json['author'],
        length: json['length']
    );
  }

  //Database model

  factory QuoteModel.fromMap(Map<String,dynamic>map){
    return QuoteModel(
        uid: map['uid'],
        content: map['content'],
        author: map['author'],
        length: map['length']
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'uid' : uid,
      'content' : content,
      'author' : author,
      'length' : length
    };
  }

}