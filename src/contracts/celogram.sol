// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
  function transfer(address, uint256) external returns (bool);
  function approve(address, uint256) external returns (bool);
  function transferFrom(address, address, uint256) external returns (bool);
  function totalSupply() external view returns (uint256);
  function balanceOf(address) external view returns (uint256);
  function allowance(address, address) external view returns (uint256);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Celogram{

uint private postLength = 0;
address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;

    struct Post{
        address user;
        string image;
        string title;
        string description;
        uint likes;
    }

    struct Comment{
        address owner;
        string description;
    }


    mapping(uint => Post) internal posts;
    mapping (uint => Comment[]) internal commentsMapping;
    mapping(address => mapping(uint => bool)) internal liked;


    function newPost(
        string memory _image,
        string memory _title,
        string memory _description
         ) 
         public {
            address _user = msg.sender;
            uint _likes = 0;

            posts[postLength] = Post(
                _user,
                _image,
                _title,
                _description,
                _likes
            );
            postLength++;
    }

    function addComment(uint _index, string memory _description) public{
        require(_index < postLength, "Post does not exist.");
        commentsMapping[_index].push(Comment(msg.sender, _description));
    }

    function likePost(uint _index) public{
        require(_index < postLength, "Post does not exist.");
        require(!liked[msg.sender][_index], "You have already liked this post.");
        liked[msg.sender][_index] = true;
        posts[_index].likes++;
    }

    function getPost(uint _index) public view returns(
        address,
        string memory,
        string memory,
        string memory,
        uint,
        Comment[] memory
    ){
         Post memory post = posts[_index];
         Comment[] memory comments = commentsMapping[_index];
         return(
             post.user,
             post.image,
             post.title,
             post.description,
             post.likes,
             comments
         );
    }

    function sendTip(uint _index, uint _ammount) public payable  {
        require(_index < postLength, "Post does not exist.");
        require(
          IERC20Token(cUsdTokenAddress).transferFrom(
             msg.sender,
             posts[_index].user,
             _ammount
          ),
          "Transfer failed."
        );
    }

    function getPostsLength() public view returns(uint){
        return(postLength);
    }     

}