// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Product {
  final String image, title, description,size;
  final int rent, id;
  final Color color;

  Product(
      {required this.image,
      required this.title,
      required this.description,
      required this.rent,
      required this.size,
      required this.id,
      required this.color});
}

List<Product> products = [
  Product(
      id: 1,
      title: "Tractor",
      rent: 1000,
      size: "Singal",
      description: "A tractor is a multi-purpose farm equipment that helps farmers achieve many goals. For instance, it is used to pull other farm equipment, it is used to harvest grains, prepare the field for sowing, and even carry and deliver the end product. Multiple different varieties of farming tractors are specially designed to accomplish one task",
      image: "assets/tractor.png",
      color: Colors.green),
  Product(
      id: 2,
      title: "Thresher",
      rent: 1000,
      size: "Singal",
      description: "Threshing is an important process after harvesting of crops like wheat and paddy. It involves beating the stem of the crops to take out grains. So, the process of separating grains from the chaff is called threshing and the implement used to thresh the crops is called a threshing machine or thresher.",
      image: "assets/thresher.jpg",
      color: Colors.green),    
  Product(
      id: 3,
      title: "Harvester",
      rent: 1000,
      size: "Singal",
      description: "Harvester is farm equipment specially designed to harvest a variety of grain croppers. A harvester is also known as a combine because it combines for separate harvesting operations, namely reaping, winnowing, threshing, and gathering. The modern-day combines and combine attachments even come with the ability to track yield data.",
      image: "assets/harvester.jpg",
      color: Colors.green),
  Product(
      id: 4,
      title: "Seeders",
      rent: 1000,
      size: "Singal",
      description: "Seeders is farm equipment that is used for sowing seeds and planting crops. Depending upon the area that needs to be covered, there are manual hand-held seeders and large tractor-pulled seeders that are used on large-scale farms",
      image: "assets/seeder.png",
      color: Colors.green),
  Product(
      id: 5,
      title: "Harrow",
      rent: 1000,
      size: "Singal",
      description: " A harrow is a large piece of farming equipment that is usually attached to tractors and is used to break the earth into small pieces to prepare the field for sowing.",
      image: "assets/plow.jpg",
      color: Colors.green),
  Product(
      id: 6,
      title: "Planters",
      rent: 1000,
      size: "Singal",
      description: "Planters tend to be the most expensive type of seeders because they sow seeds by cutting into the ground and dropping individual seeds closing the ground behind them as they move along.",
      image: "assets/planters.jpg",
      color: Colors.green),
  Product(
    id: 7,
    title: "Seed Drill",
    rent: 1000,
    size: "Singal",
    description: "A seed drill is a device used in agriculture that sows seeds for crops by positioning them in the soil and burying them to a specific depth. This ensures that seeds will be distributed evenly. The seed drill sows the seeds at the proper seeding rate and depth, ensuring that the seeds are covered by soil.",
    image: "assets/seed drill.jpg",
    color: Colors.green,),
  Product(
    id: 8,
    title: "Plough",
    rent: 1000,
    size: "Singal",
    description: "A plow is a tillage equipment that can be attached to a tractor to till the land efficiently. This machinery allows farmers to turn the soil into a nutrient-rich seedbed for better plant growth.",
    image: "assets/plough.jpg",
    color: Colors.green ),
  Product(
    id: 9,
    title: "Sprayer",
    rent: 1000,
    size: "Singal",
    description: "A sprayer is farm equipment that is used to spray insecticides, pesticides, and fertilizers on the crop. There are two major types of sprayers: agricultural aircraft sprayers and blowers sprayers. Sometimes farmers use this farm equipment to spray water and maintain humidity levels.",
    image: "assets/sprayer.jpg",
    color: Colors.green
  ),
  Product(
    id: 10,
    title: "Rakes",
    rent: 1000,
    size: "Singal",
    description: " A rake is an agricultural and horticultural tool that consists of toother bar fixed to a handle that is used to collect leaves, hay, and grass. It is an essential farm equipment used for making hay.",
    image: "assets/raker.jpg",
    color: Colors.green
  ),
  Product(
    id: 11,
    title: "Leveler",
    rent: 1000,
    size: "Singal",
    description: "Leveler is another tractor attachment that is used to make the surface of the sand more leveled and smoother to create a more environment for crops. It also helps reduce the consumption of fertilizers, seeds, pesticides, and fuels by doing so.",
    image: "assets/leveler.jpg",
    color: Colors.green
  ),
   Product(
    id: 12,
    title: "Silage Bagger",
    rent: 1000,
    size: "Singal",
    description: "Silage Bagger is used to pack and store silage, a fermented forage crop, in plastic bags for preservation. Silage baggers compress the forage and seal it in airtight bags, allowing for longer storage periods and minimizing spoilage.",
    image: "assets/bagger.jpg",
    color: Colors.green
  ),
  Product(
    id: 13,
    title: "Hay Baler",
    rent: 1000,
    size: "Singal",
    description: "Equipment used to compress and bind cut hay or straw into compact bales for storage and transportation. Hay balers come in various types, including round balers and square balers, and are crucial for preserving and handling forage crops.",
    image: "assets/hay baler.jpg",
    color: Colors.green
  ),
 
];
