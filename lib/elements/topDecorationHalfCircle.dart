class TopDecorationHalfCircle extends StatelessWidget {
  const TopDecorationHalfCircle({
    Key key,
    this.colorOne = const Color.fromARGB(255, 79, 68, 255),
    this.colorTwo = const Color.fromARGB(255, 79, 68, 255),
    this.title = "",
  }) : super(key: key);
  final Color colorOne;
  final Color colorTwo;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorOne,
            colorTwo,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 10,
            color: Theme.of(context).shadowColor,
          )
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(
            MediaQuery.of(context).size.width * 3,
            250,
          ),
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
