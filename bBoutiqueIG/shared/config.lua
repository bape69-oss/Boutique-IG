Config = {

    NameMenu = "Boutique Fidélité", --Titre du menu
    Description = "Que voulez-vous faire ?", -- Description du menu
    CoinsName = "Bcoins", --Nom du coins afficher sur le menu
    WeaponItem = false, -- true si tu as les armes en item / false si tu veux les armes de bases
    img_notif = "CHAR_SOCIAL_CLUB", --Logo des notifications
    WaitToOpenCrate = 5,

    Vehicle = true, -- true pour les mettres / false pour les enlevers
    Weapon   = true, -- true pour les mettres / false pour les enlevers
    Crate  = true, -- true pour les mettres / false pour les enlevers
    Money   = true, -- true pour les mettres / false pour les enlevers

    ListVehicle = {
        {
            NameButton = "Komoda", value = "komoda", Price = 1000
        },
        {
            NameButton = "Jugular", value = "jugular", Price = 1200
        },
        {
            NameButton = "GB-200", value = "gb200", Price = 1500
        },
        {
            NameButton = "Elegy Benny's", value = "elegy", Price = 2000
        },
        {
            NameButton = "Emerus", value = "Emerus", Price = 2500
        },
        {
            NameButton = "Italirsx", value = "italirsx", Price = 5000
        },
        {
            NameButton = "Jester (3)", value = "jester3", Price = 3000
        },
        {
            NameButton = "Paragon", value = "paragon", Price = 3500
        },
        {
            NameButton = "Schlagen", value = "schlagen", Price = 3500
        },
        {
            NameButton = "Sultan", value = "sultan", Price = 500
        }
    },
    ListCrate = {
        {
            NameButton = "Caisse mystère",
            NameYTD = "mystere",
            Description = "VOTRE DESCRIPTION",
            Price = "900",
            contenue = {
                {name = "250.000", value = "250000", count = 1, type = "money"},
                {name = "300.000", value = "300000", count = 1, type = "money"},
                {name = "Entreprise", value = "", count = 1, type = "autre"},
                {name = "Véhicule au choix", value = "", count = 1, type = "autre"},
            }
        },
        {
            NameButton = "Caisse mystère deluxe",
            NameYTD = "mysteredeluxe",
            Description = "VOTRE DESCRIPTION",
            Price = "1200",
            contenue = {
                {name = "500.000", value = "500000", count = 1, type = "money"},
                {name = "1.000.000", value = "1000000", count = 1, type = "money"},
                {name = "Entreprise", value = "", count = 1, type = "autre"},
                {name = "Véhicule au choix", count = 1, value = "", type = "autre"},
                {name = "Vodka", value = "polivakov", count = 5, type = "item"},
                {name = "Jack Daniel's", value = "jack_daniel_pomme", count = 5, type = "item"}
            }
        }
    },
    ListWeapon = {
        {
            NameButton = "Couteau", value = "weapon_knife", Price = 150
        },
        {
            NameButton = "Pistolet", value = "weapon_pistol", Price = 900
        },
        {
            NameButton = "SMG", value = "weapon_smg", Price = 1500
        },
        {
            NameButton = "AK-Compact", value = "weapon_compactrifle", Price = 10001
        }
    },
    ListMoney = {
        {
            NameButton = "5.000$", value = 5000, Price = 2500
        },
        {
            NameButton = "10.000$", value = 10000, Price = 5000
        },
        {
            NameButton = "15.000", value = 15000, Price = 7500
        },
        {
            NameButton = "20.000", value = 20000, Price = 10000
        },
        {
            NameButton = "25.000", value = 25000, Price = 12500
        }
    },

    Discord_Webhook = {
        weapon = "https://discord.com/api/webhooks/952601578093826119/B_6q6LVx4NcMIDU5lTeknDilJmy4I-AF-BprKaf9n-J6Wk0-qCFDpuglT7ElGa23ZyxW",
        vehicle = "https://discord.com/api/webhooks/952601728811950090/y7RmNWxMa0CGxyfqoc1zkTyPQ8WS0B1DLTadweg9-zRX3f_ih3irEMbWmpRDk2NEb3o0",
        money = "https://discord.com/api/webhooks/952601801415344208/Y0jDBG9mZOwOK2mibQuIN-OXnKZm3ZsOFTNMIjZHXphFADAivXaMg9ABgmE-lcEL41a0",
        crate = "https://discord.com/api/webhooks/952601664387432448/fviHkaeAjKZzYPU27zQmlfjNQh9wHFqMMlzZi1oncOR1lYEg0QNaJfJBbEBuRVmPx5Lr"
    }
}