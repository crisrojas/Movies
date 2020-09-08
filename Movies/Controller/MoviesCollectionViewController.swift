//
//  MoviesCollectionViewController.swift
//  Movies
//
//  Created by Cristian Rojas on 07/09/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "MoviesCell"

final class MoviesCollectionViewController: UICollectionViewController {

    let movies = Movies(
        results: [
            Movie(
                id: 577922,
                posterPath: "/aCIFMriQh8rvhxpN1IWGgvH0Tlg.jpg",
                title: "Tenet",
                overview: "John David Washington est le nouveau protagoniste dans le spectacle original de science-fiction signé Christpher Nolan, Tenet. Armé d'un seul mot - Tenet - et se battant pour la survie du monde entier, le protagoniste voyage à travers le monde crépusculaire de l'espionnage international dans une mission qui se déroulera au delà du temps réel. Pas un voyage dans le temps... l'inversion."
            ),
            Movie(
                id: 340102,
                posterPath: "/aYHaR3FhKjipcy499YjCPRv4vcz.jpg",
                title: "Les Nouveaux mutants",
                overview: "Les Mutants sont les plus dangereux, pour eux-mêmes comme pour les autres, lorsqu’ils découvrent leurs pouvoirs. Détenus dans une division secrète contre leur volonté,  cinq nouveaux mutants doivent apprivoiser leurs dons et assumer les erreurs graves de leur passé. Traqués par une puissance surnaturelle, leurs peurs les plus terrifiantes vont devenir réalité."
            ),
            Movie(
                id: 579583,
                posterPath: "/wIYkb0mS9WY53a2dOqCrg0xaSpt.jpg",
                title: "The King of Staten Island",
                overview: "Il semblerait que le développement de Scott ait largement été freiné depuis le décès de son père pompier, quand il avait 7 ans. Il en a aujourd’hui 24 et entretient le rêve peu réaliste d’ouvrir un restaurant-salon de tatouage.  Alors que sa jeune sœur Claire, raisonnable et bonne élève, part étudier à l’université, Scott vit toujours aux crochets de sa mère infirmière, Margie, et passe le plus clair de son temps à fumer de l’herbe, à traîner avec ses potes Oscar, Igor et Richie et à sortir en cachette avec son amie d’enfance Kelsey.  Mais quand sa mère commence à fréquenter Ray, un pompier volubile, Scott va voir sa vie chamboulée et ses angoisses exacerbées. L’adolescent attardé qu’il est resté va devoir enfin faire face à ses responsabilités et au deuil de son père..."
            ),
            Movie(
                id: 449924,
                posterPath: "/wC4gUfdacoZdWOf3wBoYhyOHFcc.jpg",
                title: "Ip Man 4 : Le dernier combat",
                overview: "Le maître de Kung Fu se rend aux États-Unis où son élève a bouleversé la communauté locale des arts martiaux en ouvrant une école de Wing Chun."
            ),
            Movie(
                id: 486589,
                posterPath: "/MBiKqTsouYqAACLYNDadsjhhC0.jpg",
                title: "Blanche Neige, les souliers rouges et les 7 nains",
                overview: "Les princes qui ont été transformés en nains cherchent les souliers rouges d'une dame afin de rompre le charme, bien que ce ne soit pas facile..."
            ),
            Movie(
                id: 524047,
                posterPath: "/fDs3sjibzfEhhMbbJ5V5PMR3527.jpg",
                title: "Greenland - Le dernier refuge",
                overview: "Une comète est sur le point de s’écraser sur la Terre et de provoquer un cataclysme sans précédent. John Garrity décide de se lancer dans un périlleux voyage avec son ex-épouse Allison et leur fils Nathan pour rejoindre le dernier refuge sur Terre à l’abri du désastre. Alors que l’urgence devient absolue et que les catastrophes s’enchainent de façon effrénée, les Garrity vont être témoin du meilleur comme du pire de la part d’une humanité paniquée au milieu de ce chaos."
            ),
            Movie(
                id: 550738,
                posterPath: "/jvv313GJcCYbPbRDqKt2Vi3BDzt.jpg",
                title: "Spycies",
                overview: "Vladimir et Hector, deux agents secrets que tout oppose vont devoir s'allier pour retrouver des données secrètes volées."
            ),
            Movie(
                id: 592350,
                posterPath: "/gX8bssPezUidGFWJT1g7yM72oXq.jpg",
                title: "My Hero Academia: Heroes Rising",
                overview: "La classe 1-A de U.A. a été envoyée sur l’île isolée de Nabu dans le cadre d’un programme de sécurité, ce qui équivaut à des actes mineurs de la part des étudiants, car l’île est pratiquement exempte de criminalité. Izuku Midoriya, titulaire du One for All, un pouvoir d’une immense puissance héritée, rencontre Mahoro Shimano et son frère Katsuma, résidents de l’île. S’unissant à eux avec son rival Katsuki Bakugo, ils découvrent que Katsuma souhaite devenir un héros, mais Mahoro cherche à le dissuader, estimant que son Alter n’est pas adapté à une ligne de travail dangereuse.Pendant ce temps, le père de Mahoro et Katsuma, qui possède un Alter curatif appelé Cell Activation, est attaqué par Nine et son groupe."
            ),
            Movie(
                id: 625568,
                posterPath: "/e7bpDu3RKsjOYLSt9gHYT2c32Zd.jpg",
                title: "Enragé",
                overview: "Mauvaise journée pour Rachel : en retard pour conduire son fils à l’école, elle se retrouve coincée au feu derrière une voiture qui ne redémarre pas. Perdant patience, elle klaxonne et passe devant. Quelques mètres plus loin, le même pick up s’arrête à son niveau. Son conducteur la somme de s’excuser, mais elle refuse. Furieux, il commence à la suivre... La journée de Rachel se transforme en véritable cauchemar."
            ),
            Movie(
                id: 595671,
                posterPath: "/e7bpDu3RKsjOYLSt9gHYT2c32Zd.jpg",
                title: "Never Rarely Sometimes Always",
                overview: "Deux adolescentes, Autumn et sa cousine Skylar, résident au sein d'une zone rurale de Pennsylvanie. Autumn doit faire face à une grossesse non-désirée. Ne bénéficiant d'aucun soutient de la part de sa famille et de la communauté locale, les deux jeunes femmes se lancent dans un périple semé d'embûches jusqu'à New York."
            )
        ]
    )
    
    private let itemsPerRow : CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 50.0,
    left: 20.0,
    bottom: 50.0,
    right: 20.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(MoviesCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}


extension MoviesCollectionViewController {
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.results.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        ///todo: Return cell as MovieCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MoviesCell
    
        //cell.backgroundColor = .black // Configure the cell
        guard let urlString = self.movies.results[indexPath.row].poster else { return cell }
        let url = URL(string: urlString)
        cell.imageView.kf.setImage(with: url)


        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    /// Sets the layout size for a given cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      //2
      let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
      let availableWidth = view.frame.width - paddingSpace
      let widthPerItem = availableWidth / itemsPerRow
      
      return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
      return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return sectionInsets.left
    }
}
