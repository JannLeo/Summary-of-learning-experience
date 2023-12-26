--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: maximum_price(double precision); Type: FUNCTION; Schema: public; Owner: liuyuwen_2018152068
--

CREATE FUNCTION public.maximum_price(maxp double precision) RETURNS TABLE(description character varying, location character varying, deal_price double precision, available_date date, ending_date date)
    LANGUAGE plpgsql
    AS $_$
BEGIN RETURN QUERY SELECT c.description, c.location, c.deal_price, c.available_date, c.ending_date
FROM coupons_form AS c
WHERE c.deal_price <= $1
ORDER BY c.deal_price DESC;
END; $_$;


ALTER FUNCTION public.maximum_price(maxp double precision) OWNER TO liuyuwen_2018152068;

--
-- Name: more_than_100(); Type: FUNCTION; Schema: public; Owner: liuyuwen_2018152068
--

CREATE FUNCTION public.more_than_100() RETURNS TABLE(deal_number integer, description character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
SELECT s.deal_number, c.description FROM (SELECT s0.deal_number FROM sign_up_form AS s0  GROUP BY s0.deal_number HAVING COUNT(s0.sign_up_number) >= 100) AS s
INNER JOIN coupons_form AS c
ON s.deal_number = c.deal_number;
END;
$$;


ALTER FUNCTION public.more_than_100() OWNER TO liuyuwen_2018152068;

--
-- Name: most_popular_deal(); Type: FUNCTION; Schema: public; Owner: liuyuwen_2018152068
--

CREATE FUNCTION public.most_popular_deal() RETURNS TABLE(deal_number integer, description character varying, enrollments bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN 
RETURN QUERY
SELECT c.deal_number, c.description, s.enrollments
FROM
(SELECT s0.deal_number, COUNT(s0.sign_up_number) AS enrollments FROM sign_up_form AS s0  GROUP BY s0.deal_number) AS s
INNER JOIN
coupons_form AS c
ON s.deal_number = c.deal_number ORDER BY s.enrollments DESC;
END;
$$;


ALTER FUNCTION public.most_popular_deal() OWNER TO liuyuwen_2018152068;

--
-- Name: percentage_bargain(); Type: FUNCTION; Schema: public; Owner: liuyuwen_2018152068
--

CREATE FUNCTION public.percentage_bargain() RETURNS TABLE(deal_number integer, description character varying, location character varying, deal_price double precision, original_price double precision, bargain text)
    LANGUAGE plpgsql
    AS $$
BEGIN RETURN QUERY SELECT c.deal_number, c.description, c.location, c.deal_price, c.original_price, (ROUND(CAST((1-c.deal_price/c.original_price) AS numeric) * 100, 2) || '%') AS bargain FROM coupons_form AS c ORDER BY bargain DESC;
END; $$;


ALTER FUNCTION public.percentage_bargain() OWNER TO liuyuwen_2018152068;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: coupons_form; Type: TABLE; Schema: public; Owner: liuyuwen_2018152068
--

CREATE TABLE public.coupons_form (
    deal_number integer NOT NULL,
    description character varying(40) NOT NULL,
    location character varying(15) NOT NULL,
    deal_price double precision NOT NULL,
    original_price double precision NOT NULL,
    available_date date NOT NULL,
    ending_date date NOT NULL
);


ALTER TABLE public.coupons_form OWNER TO liuyuwen_2018152068;

--
-- Name: coupons_form_deal_number_seq; Type: SEQUENCE; Schema: public; Owner: liuyuwen_2018152068
--

CREATE SEQUENCE public.coupons_form_deal_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupons_form_deal_number_seq OWNER TO liuyuwen_2018152068;

--
-- Name: coupons_form_deal_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: liuyuwen_2018152068
--

ALTER SEQUENCE public.coupons_form_deal_number_seq OWNED BY public.coupons_form.deal_number;


--
-- Name: customer_form; Type: TABLE; Schema: public; Owner: liuyuwen_2018152068
--

CREATE TABLE public.customer_form (
    customer_number character varying(30) NOT NULL,
    name character varying(30) NOT NULL,
    email character varying(30) NOT NULL
);


ALTER TABLE public.customer_form OWNER TO liuyuwen_2018152068;

--
-- Name: sign_up_form; Type: TABLE; Schema: public; Owner: liuyuwen_2018152068
--

CREATE TABLE public.sign_up_form (
    sign_up_number integer NOT NULL,
    customer_number character varying(30),
    deal_number integer
);


ALTER TABLE public.sign_up_form OWNER TO liuyuwen_2018152068;

--
-- Name: sign_up_form_sign_up_number_seq; Type: SEQUENCE; Schema: public; Owner: liuyuwen_2018152068
--

CREATE SEQUENCE public.sign_up_form_sign_up_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sign_up_form_sign_up_number_seq OWNER TO liuyuwen_2018152068;

--
-- Name: sign_up_form_sign_up_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: liuyuwen_2018152068
--

ALTER SEQUENCE public.sign_up_form_sign_up_number_seq OWNED BY public.sign_up_form.sign_up_number;


--
-- Name: coupons_form deal_number; Type: DEFAULT; Schema: public; Owner: liuyuwen_2018152068
--

ALTER TABLE ONLY public.coupons_form ALTER COLUMN deal_number SET DEFAULT nextval('public.coupons_form_deal_number_seq'::regclass);


--
-- Name: sign_up_form sign_up_number; Type: DEFAULT; Schema: public; Owner: liuyuwen_2018152068
--

ALTER TABLE ONLY public.sign_up_form ALTER COLUMN sign_up_number SET DEFAULT nextval('public.sign_up_form_sign_up_number_seq'::regclass);


--
-- Data for Name: coupons_form; Type: TABLE DATA; Schema: public; Owner: liuyuwen_2018152068
--

COPY public.coupons_form (deal_number, description, location, deal_price, original_price, available_date, ending_date) FROM stdin;
101	Fall Foliage Helicopter Tour	Chicago, IL	189	450	2012-10-05	2012-11-06
102	18 Hole Golf Heritage Golf Center	Chicago, IL	28	64	2012-09-02	2012-09-15
103	Hamburgers, Etc Restaurant	Chicago, IL	12	25	2012-09-20	2012-09-22
104	Segway City Tour - 3 hours	Chicago, IL	35	70	2012-09-18	2012-09-19
105	Spas Unlimited	Chicago, IL	25	50	2012-10-01	2012-10-10
\.


--
-- Data for Name: customer_form; Type: TABLE DATA; Schema: public; Owner: liuyuwen_2018152068
--

COPY public.customer_form (customer_number, name, email) FROM stdin;
C2000	B Duncan	MEEHGGLY3@comcast.com
C2001	N Garnett	AATXMSBF3@comcast.com
C2002	K James	GHXCIXPN2@verizon.com
C2003	A Nash	CHDEAQWS2@verizon.com
C2004	A Jefferson	ZKCPVWFH3@comcast.com
C2005	E Camby	GOKUAVVN2@verizon.com
C2006	N Carter	GEHBWYBJ3@comcast.com
C2007	C Wade	CEFJIEMR2@verizon.com
C2008	P Marion	UIANFYVQ3@comcast.com
C2009	J Webber	YJMBEUXH1@gmail.com
C2010	D Okur	SBDYLCBF1@gmail.com
C2011	M Nowitzki	BFNOTXFB1@gmail.com
C2012	H Kidd	ULVFLMAL1@gmail.com
C2013	W Iverson	AEVMDDGO2@verizon.com
C2014	W Bryant	KLXQBDEJ2@verizon.com
C2015	O Walker	XUAJWLAI3@comcast.com
C2016	U Wallace	WEGYJWHX2@verizon.com
C2017	C Kirilenko	THCZXPAA2@verizon.com
C2018	X Brand	TNQFHHVI2@verizon.com
C2019	P Gasol	PEHWXBFS3@comcast.com
C2020	E Mobley	QPLYQHPC1@gmail.com
C2021	I Arenas	GGLDKGGS1@gmail.com
C2022	O Redd	EKSUUNXO2@verizon.com
C2023	N Bosh	JYGAQQLH2@verizon.com
C2024	I Gooden	TUZWHLPL2@verizon.com
C2025	E Iguodala	YZFSDTMF2@verizon.com
C2026	S Jones	ONSCKMAP2@verizon.com
C2027	M Odom	HYJCDILF3@comcast.com
C2028	O O'Neal	BIRRRWLW3@comcast.com
C2029	W Jaric	SVONDSGR2@verizon.com
C2030	Y Anthony	JVUJAOPQ3@comcast.com
C2031	P Jones	RLESUPPX1@gmail.com
C2032	S Cassell	BHEEFXYB2@verizon.com
C2033	O Parker	IDAIGUZK2@verizon.com
C2034	F Parker	IPXIPHUD2@verizon.com
C2035	G Knight	ARRUBQTX2@verizon.com
C2036	V Pierce	HHIKTSQH3@comcast.com
C2037	T Peterson	RLRZPOYJ3@comcast.com
C2038	R Duhon	IJZGMJYK2@verizon.com
C2039	T West	PRBXIMPS3@comcast.com
C2040	B Okafor	USBSUVYD2@verizon.com
C2041	N Jamison	OMTJRPLP2@verizon.com
C2042	S Diaw-Riffiod	HLFZRZPE1@gmail.com
C2043	I Hamilton	DFMSGQAK2@verizon.com
C2044	T Tinsley	EMZKQLCJ2@verizon.com
C2045	X Paul	NPSOENDW2@verizon.com
C2046	W Allen	EHOUCNBC2@verizon.com
C2047	T Ford	CLIIZBOH1@gmail.com
C2048	C Wallace	ITEMEPHM3@comcast.com
C2049	A Ilgauskas	ZMTWDDUQ2@verizon.com
C2050	T Williams	HBYYRBCE2@verizon.com
C2051	N Stojakovic	ZTCRYWMP3@comcast.com
C2052	T James	ZQWQUHLS3@comcast.com
C2053	V Davis	OZQTGBSA3@comcast.com
C2054	S Miller	HGVYPVIC2@verizon.com
C2055	V Simmons	UDJATOZJ2@verizon.com
C2056	U Francis	PPDGNAHJ3@comcast.com
C2057	D Wells	DTZNNNZV3@comcast.com
C2058	L Hunter	OSKOHXQY2@verizon.com
C2059	V Calderon	JLLNDOSZ3@comcast.com
C2060	D Miller	MEWENLVA2@verizon.com
C2061	C Marshall	WVUCRXLK2@verizon.com
C2062	H Johnson	CJUQKOOS1@gmail.com
C2063	U Richardson	UPJDCRTM2@verizon.com
C2064	H Blount	LXFECLPS3@comcast.com
C2065	N Claxton	GIJVARRH2@verizon.com
C2066	Y Abdur-Rahim	ZRSDAEZG1@gmail.com
C2067	O Bell	QSKMHBIB1@gmail.com
C2068	M Barbosa	SLOTDFRH3@comcast.com
C2069	I Horry	FMVXDYER1@gmail.com
C2070	G Haslem	EVEYAGUS2@verizon.com
C2071	N Croshere	SHMRBNWU1@gmail.com
C2072	Z Howard	XMONCJOP1@gmail.com
C2073	S Hughes	IZJMDUHV1@gmail.com
C2074	N LaFrentz	LPBNOPJI1@gmail.com
C2075	G Mourning	NDVVPCWW1@gmail.com
C2076	X Artest	CLEAQPFJ2@verizon.com
C2077	V Hinrich	PAPYNQSZ2@verizon.com
C2078	N Martin	OLHFPMIY3@comcast.com
C2079	S Haywood	BUJCFQTY2@verizon.com
C2080	Y Ming	CNZYUSXA1@gmail.com
C2081	J Prince	SAJXUCXM3@comcast.com
C2082	L Miles	EZKHANFA2@verizon.com
C2083	V Ginobili	HJTWOZNP1@gmail.com
C2084	Y Billups	VKDKTABG2@verizon.com
C2085	C Williams	EOXLXVOD1@gmail.com
C2086	T Krstic	DEOBTYLD2@verizon.com
C2087	C Brown	LCREVBWD1@gmail.com
C2088	Y Lewis	PTYDXEXP3@comcast.com
C2089	U Smith	KCDOLINC2@verizon.com
C2090	O Rose	XSLMAXCF3@comcast.com
C2091	M Payton	OIQFUYIC3@comcast.com
C2092	W West	XPIMXTAV1@gmail.com
C2093	R Childress	VSBZBIPY2@verizon.com
C2094	J Ostertag	QBJTZPXL2@verizon.com
C2095	Z Battier	PCLKILWH2@verizon.com
C2096	P Bogut	NXIMBKQI3@comcast.com
C2097	A Lenard	SEAMAHHD3@comcast.com
C2098	S Jones	VQXRDLSY3@comcast.com
C2099	L Przybilla	LENMZIKL1@gmail.com
C2100	T Terry	FQNQZGPE3@comcast.com
C2101	R Kaman	UZDEATPN1@gmail.com
C2102	H Sweetney	YUCOEARM3@comcast.com
C2103	J Griffin	THBSLWXR1@gmail.com
C2104	Z Fisher	MGTEVKWZ2@verizon.com
C2105	S Jackson	SLEAACNU1@gmail.com
C2106	Z Stoudamire	JXOKLNMW3@comcast.com
C2107	R Olowokandi	YLQUHHDY1@gmail.com
C2108	Z Gordon	XGDHVFII3@comcast.com
C2109	F House	HRXCQDYB1@gmail.com
C2110	F Wallace	QRMNOPSB2@verizon.com
C2111	C Evans	IHRPQMIZ2@verizon.com
C2112	G Brezec	IBAAVICG2@verizon.com
C2113	A Stevenson	VZWGQDWX3@comcast.com
C2114	Z Pachulia	OLZLUYAH1@gmail.com
C2115	T Magloire	CLWRBPHY3@comcast.com
C2116	D Smith	IOHQWDOF1@gmail.com
C2117	M Barry	DPVVBSFO1@gmail.com
C2118	M Davis	YMFPMKHD3@comcast.com
C2119	V Ridnour	WBVVYFJO1@gmail.com
C2120	S Ely	RTZYKGPJ1@gmail.com
C2121	Q Felton	CGEJNOYO2@verizon.com
C2122	K Thomas	QKWQZLRD3@comcast.com
C2123	J Miller	UVHXDIOX1@gmail.com
C2124	V Buckner	IQXUESEA3@comcast.com
C2125	M Szczerbiak	WLZMKJWZ2@verizon.com
C2126	J Ariza	VTSNKAMG1@gmail.com
C2127	S Murphy	IRSBWPPN3@comcast.com
C2128	X Van	SMWKTHCY3@comcast.com
C2129	Q Turkoglu	GNJZQZZH3@comcast.com
C2130	Q Harpring	IBHEGTID1@gmail.com
C2131	R Jasikevicius	NLVUHLRY1@gmail.com
C2132	K Ross	LXNCVMTZ1@gmail.com
C2133	Z Daniels	CUTFCSBY1@gmail.com
C2134	M Anderson	GFFRZSWV3@comcast.com
C2135	W Boykins	QYTHVSPE3@comcast.com
C2136	G Randolph	UPHGAWGQ1@gmail.com
C2137	K Bowen	KDAECGME2@verizon.com
C2138	U Alston	ODAFLTLG1@gmail.com
C2139	L Elson	QDYWDBWU1@gmail.com
C2140	P Chandler	OKXBQPHY1@gmail.com
C2141	X McLeod	MKJBMZCE3@comcast.com
C2142	B George	LRDWXHKC3@comcast.com
C2143	C Kapono	ZSYMPJVE1@gmail.com
C2144	B Williams	OOHBSZRA2@verizon.com
C2145	M Korver	XKHOUJXV3@comcast.com
C2146	A Hudson	HQMSDHWA1@gmail.com
C2147	A Telfair	RAFYVQCJ3@comcast.com
C2148	A Villanueva	CBZNIKWL3@comcast.com
C2149	Z Songaila	DGKNHDXH2@verizon.com
C2150	M Pujols	MNGXHYBQ3@comcast.com
C2151	M Rodriguez	VSASILUW3@comcast.com
C2152	A Guerrero	YEPVGWRQ2@verizon.com
C2153	V Beltran	KVBRDSUT2@verizon.com
C2154	G Santana	RMRJYFRX1@gmail.com
C2155	M Tejada	YBWUUTZH1@gmail.com
C2156	J Helton	VUGPTQLV1@gmail.com
C2157	A Soriano	SFSFGRFY2@verizon.com
C2158	L Johnson	UUJXAQOE1@gmail.com
C2159	A Ramirez	KNJUYHCU3@comcast.com
C2160	N Abreu	NNHROZDD2@verizon.com
C2161	Y Suzuki	BEEVVTHE1@gmail.com
C2162	K Sheffield	CJXUHBAL2@verizon.com
C2163	O Rolen	MPDQBURK3@comcast.com
C2164	B Schmidt	URDEVLKX1@gmail.com
C2165	H Crawford	ZPWWERXG2@verizon.com
C2166	B Prior	FXEFICYB2@verizon.com
C2167	J Thome	JIUPKDHN2@verizon.com
C2168	N Schilling	QWVEJJIY3@comcast.com
C2169	K Lee	ZWPIENAE3@comcast.com
C2170	D Teixeira	HFTRWCVN1@gmail.com
C2171	X Martinez	GQNHENDR2@verizon.com
C2172	Q Cabrera	JTBNXHEN3@comcast.com
C2173	E Oswalt	RRAMKGGH3@comcast.com
C2174	P Roberts	YIPQKPZV3@comcast.com
C2175	I Pierre	XGYXEJFX1@gmail.com
C2176	K Beltre	NTEEVFGM3@comcast.com
C2177	P Sheets	QDXUGMDP2@verizon.com
C2178	Z Huff	CCMXGTAM1@gmail.com
C2179	W Ortiz	CCUDTQUM1@gmail.com
C2180	D Edmonds	HKWCEZYQ2@verizon.com
C2181	Q Zambrano	OLXZTKTJ3@comcast.com
C2182	W Jeter	WSSEBBML2@verizon.com
C2183	D Rivera	OYQEWFTW3@comcast.com
C2184	L Gagne	SCVYKAFA2@verizon.com
C2185	B Hudson	HCFMIEDI1@gmail.com
C2186	I Patterson	VPHYWEFF2@verizon.com
C2187	T Lidge	RWDICZTQ2@verizon.com
C2188	T Ramirez	WMCJRJGV2@verizon.com
C2189	B Blalock	VNRFQVQT2@verizon.com
C2190	D Mora	GKGRGMFE2@verizon.com
C2191	A Peavy	JKVCFXLZ1@gmail.com
C2192	N Matsui	FLEJAMJX1@gmail.com
C2193	B Chavez	SSPSQTKI3@comcast.com
C2194	P Lee	SHNDWXKJ1@gmail.com
C2195	J Foulke	DIODICDU2@verizon.com
C2196	O Dunn	NIBNRCFY2@verizon.com
C2197	G Young	CTOOYNTY2@verizon.com
C2198	A Lopez	EROLOMAP2@verizon.com
C2199	G Delgado	XFYPUUHI2@verizon.com
C2200	R Wood	HSURARSP3@comcast.com
C2201	P Kent	DUMPKRRX1@gmail.com
C2202	Z Renteria	QRDKTION3@comcast.com
C2203	T Rodriguez	DJJIWJNC3@comcast.com
C2204	W Morneau	BSTJYYOF1@gmail.com
C2205	D Giles	RIGHEGZZ2@verizon.com
C2206	E Clemens	LMWTVPDZ2@verizon.com
C2207	X Jones	QQDIZEZJ2@verizon.com
C2208	W Martinez	AAXMVPLU3@comcast.com
C2209	N Pavano	CPCNGYWH3@comcast.com
C2210	E Rodriguez	DLECQQIH3@comcast.com
C2211	W Furcal	GAMXSBOQ2@verizon.com
C2212	H Nathan	GYUUWOGW2@verizon.com
C2213	Q Boone	ILYYLXJQ3@comcast.com
C2214	V Wagner	RJDDWUQT2@verizon.com
C2215	N Hafner	DJGHWZTP3@comcast.com
C2216	R Cordero	VVRFOEBN2@verizon.com
C2217	Q Damon	XAIHPIBX2@verizon.com
C2218	Y Dotel	NHRIIEKH2@verizon.com
C2219	B Loretta	HQNXYUVX2@verizon.com
C2220	Q Sosa	LVYXMGMS1@gmail.com
C2221	Y Mussina	HKEXFXPU1@gmail.com
C2222	A Perez	QIGKCUFY2@verizon.com
C2223	V Wells	UIMZKCIV2@verizon.com
C2224	I Wright	MVUPQPDL3@comcast.com
C2225	Y Giles	TMLHBJRB2@verizon.com
C2226	K Mulder	MXKOUZVX1@gmail.com
C2227	R Berkman	MEHNEEQE2@verizon.com
C2228	O Posada	VSMLGWAL1@gmail.com
C2229	I Smoltz	LHHCNOFQ3@comcast.com
C2230	C Rollins	SUSBKRES3@comcast.com
C2231	Y Harden	FEOEDJYA1@gmail.com
C2232	P Isringhausen	YEHNSKQM3@comcast.com
C2233	O Sexson	HNUOEUQB1@gmail.com
C2234	P Podsednik	WAVMAWLB2@verizon.com
C2235	G Drew	OMFAWODH2@verizon.com
C2236	J Hoffman	FTZZIQYX1@gmail.com
C2237	Q Halladay	EKWXBQGE3@comcast.com
C2238	W Jones	MJKUOLBN3@comcast.com
C2239	Y Buehrle	JYCFKHVR3@comcast.com
C2240	Z Lowell	GWMEJNGN2@verizon.com
C2241	B Anderson	CVWCXFAU2@verizon.com
C2242	A Bay	CXIAOGGW2@verizon.com
C2243	W Guillen	ELKQWXEL1@gmail.com
C2244	T Konerko	AIKIRLFM1@gmail.com
C2245	C Green	DEPQJJAO1@gmail.com
C2246	A Reyes	OSZDTNMP3@comcast.com
C2247	M Vidro	XASGIJUW2@verizon.com
C2248	D Utley	EBDYFLUS2@verizon.com
C2249	K Garland	EHIVTXSP3@comcast.com
C2250	K Willis	WUBFLBAC2@verizon.com
C2251	F Hernandez	RTYXUGCF1@gmail.com
C2252	F Mota	KKSHYQHV3@comcast.com
C2253	X Glaus	DSRURPTA1@gmail.com
C2254	V Vazquez	PLOCCLHR1@gmail.com
C2255	X Casey	BVUOEGGF3@comcast.com
C2256	Z Hunter	ULHZHBHP2@verizon.com
C2257	L Varitek	RYFSONOA2@verizon.com
C2258	B Bagwell	FIIKZDPB1@gmail.com
C2259	N Zito	MKOQHWIZ2@verizon.com
C2260	G Finley	OLAACIAL3@comcast.com
C2261	D Perez	PASXTEBR1@gmail.com
C2262	U Colon	IQHITBVR2@verizon.com
C2263	Q Guillen	EEYLGAOI3@comcast.com
C2264	E Figgins	IEIZXKAQ3@comcast.com
C2265	C Radke	SMXLUYHJ3@comcast.com
C2266	I Wilkerson	BJCMQQRA1@gmail.com
C2267	U Kendall	PLYFHRQA3@comcast.com
C2268	Q Maddux	WDKFVJOQ3@comcast.com
C2269	Q Beckett	CJYYCYUI1@gmail.com
C2270	Y Percival	IGAIKUFI1@gmail.com
C2271	V Garcia	DENNLWWA3@comcast.com
C2272	T Burnett	FKCSNKEC2@verizon.com
C2273	T Guardado	QODAANUD1@gmail.com
C2274	L Sabathia	XUHYCTWX3@comcast.com
C2275	N Clement	JEZVLKFH2@verizon.com
C2276	R Kolb	KQKVRHVT3@comcast.com
C2277	C Durazo	CWVVAUWB3@comcast.com
C2278	J Piazza	RVYAQMOE2@verizon.com
C2279	Q Rowand	TMGHQUMJ3@comcast.com
C2280	H Cabrera	JUJRHGYB2@verizon.com
C2281	J Looper	WMJKTRII2@verizon.com
C2282	R Wells	NDYDEDHL3@comcast.com
C2283	B Cordero	WSEFRYMG2@verizon.com
C2284	H Alou	PHFWPAHJ3@comcast.com
C2285	E Mauer	UTWVCIEC2@verizon.com
C2286	Q Winn	WXRZNYPL3@comcast.com
C2287	I Weaver	ENMWRMZF2@verizon.com
C2288	E Greinke	MCCNYFCP3@comcast.com
C2289	T Gonzalez	JUSCBNSM3@comcast.com
C2290	V Bonderman	PVPHRVOU1@gmail.com
C2291	E Boone	KXAORYAE1@gmail.com
C2292	R Ryan	MFBQPAJC1@gmail.com
C2293	J Castillo	ZTGAHXDG2@verizon.com
C2294	T Arroyo	IUWRIBZM1@gmail.com
C2295	G LoDuca	TUFVOTUI1@gmail.com
C2296	S Escobar	LENQIPIK1@gmail.com
C2297	U Takatsu	BWCXMPRP3@comcast.com
C2298	J Westbrook	DAFHWLDT3@comcast.com
C2299	W Ordonez	ULPOLPLG3@comcast.com
C2300	R Barmes	WICXURHI3@comcast.com
C2301	C Ford	OTJXIRQN2@verizon.com
C2302	T Young	DMXRTAGN2@verizon.com
C2303	N Carpenter	IGRQDEGV1@gmail.com
C2304	A Millar	KQQPJUAC1@gmail.com
C2305	R Pettitte	FMNZOJXH3@comcast.com
C2306	P Estrada	CJUXHCZP1@gmail.com
C2307	V Nevin	BGGWPHOS3@comcast.com
C2308	H Matsui	DQLMNYVN1@gmail.com
C2309	S Overbay	ZQJGGSYP1@gmail.com
C2310	U Lieber	YNSIKWQR3@comcast.com
C2311	K Leiter	MYTZSSMM1@gmail.com
C2312	B Sweeney	IZKJISKO1@gmail.com
C2313	P Hillenbrand	WZLRAZXS2@verizon.com
C2314	Y Crosby	VTNKDPNI1@gmail.com
C2315	Y Koskie	BINOVPDP1@gmail.com
C2316	W Lieberthal	CIQMWKGC1@gmail.com
C2317	V Durham	XWWEREEQ2@verizon.com
C2318	W Baez	FVKIROSM3@comcast.com
C2319	X McPherson	LIMBOUHA3@comcast.com
C2320	Z Lilly	TFLVJRCW3@comcast.com
C2321	J Cuddyer	JZCIGQLF3@comcast.com
C2322	D Uribe	NLCSVXQJ1@gmail.com
C2323	L Hawkins	PHOKELJJ1@gmail.com
C2324	C Palmeiro	WGQBNJZO2@verizon.com
C2325	I Greene	QZHMLZHP2@verizon.com
C2326	I Bradley	XMFOPJYN3@comcast.com
C2327	B Cameron	EYDNLWTN2@verizon.com
C2328	D Jones	OMLAVAYU1@gmail.com
C2329	W Lawrence	SZUDCTRY2@verizon.com
C2330	K Crisp	YUJOSKZJ2@verizon.com
C2331	Q Womack	NVBFXHGS2@verizon.com
C2332	M Jenkins	HHNXOCLR1@gmail.com
C2333	I Walker	SYYJHDAQ1@gmail.com
C2334	M Broussard	ABWRBOSC2@verizon.com
C2335	R Sanders	TTOUGKJI3@comcast.com
C2336	M Burnitz	ANTPQYLO3@comcast.com
C2337	R Penny	SIUAKELI2@verizon.com
C2338	B Barrett	RJNMERDA3@comcast.com
C2339	L Hidalgo	YIRHSPDF3@comcast.com
C2340	O Floyd	EYJNHTJS3@comcast.com
C2341	C Stewart	ZMWAQAXD3@comcast.com
C2342	L Pierzynski	ZGYRRXIC2@verizon.com
C2343	G Mench	OVDGULTW3@comcast.com
C2344	V Bellhorn	LBNFWQOJ1@gmail.com
C2345	H Berroa	NISSCPZZ1@gmail.com
C2346	U Blake	IAMPPUIS1@gmail.com
C2347	E Eaton	CHUTSNZB3@comcast.com
C2348	P Wright	XCAAFLSU3@comcast.com
C2349	N LaRoche	ZORZVSKU3@comcast.com
C2350	J Legace	TLZMGOOT2@verizon.com
C2351	P Hasek	IEIEWFHW3@comcast.com
C2352	E Kiprusoff	EEXRNLHM2@verizon.com
C2353	W Labarbera	IYZAUBON2@verizon.com
C2354	R Lundqvist	HOWXSAQT3@comcast.com
C2355	A Jagr	KQLSJFKI1@gmail.com
C2356	N Heatley	JRNLQARA1@gmail.com
C2357	Z Fernandez	XDCMRUYU3@comcast.com
C2358	U Alfredsson	PJTVJWXZ2@verizon.com
C2359	A Joseph	BPBDNXWP2@verizon.com
C2360	U McCabe	HQXWVOFD1@gmail.com
C2361	K Vokoun	WFTTRLEW3@comcast.com
C2362	T Visnovsky	TOHDCKAY1@gmail.com
C2363	J Salo	TUMSJTTR1@gmail.com
C2364	M Gagne	BFLYXFLT1@gmail.com
C2365	W Luongo	QSXVEVVW1@gmail.com
C2366	W Staal	YHTEEMGJ3@comcast.com
C2367	E Giguere	EFBYCNOE1@gmail.com
C2368	Y Redden	ZZCUVQHT1@gmail.com
C2369	Y Roloson	KGCYBQEU3@comcast.com
C2370	W Selanne	JPXNSLFO3@comcast.com
C2371	B Spezza	KJQPGLWR3@comcast.com
C2372	U Mara	QCOZVJYL3@comcast.com
C2373	N Chara	NKHNOVNE2@verizon.com
C2374	R Forsberg	ZAENCBOY1@gmail.com
C2375	E Auld	MFODQUVG1@gmail.com
C2376	O Lecavalier	TJRWBNIS2@verizon.com
C2377	I Gerber	WGVXLYMN3@comcast.com
C2378	L Jovanovski	EUATGUGM3@comcast.com
C2379	H Schaefer	YNTYNCXK3@comcast.com
C2380	X Liles	MXKMRVGV3@comcast.com
C2381	H Markkanen	RNMTNHXL2@verizon.com
C2382	P Miller	UVGRTAYU3@comcast.com
C2383	D Naslund	PFMJJNCW1@gmail.com
C2384	Y Demitra	VXMENPAL3@comcast.com
C2385	G Theodore	NJZBYHGJ1@gmail.com
C2386	D Schneider	XBYXHTWL2@verizon.com
C2387	L Shanahan	HUVESYVE1@gmail.com
C2388	G Murray	THSILKLB1@gmail.com
C2389	B Hossa	XGKUDUUI1@gmail.com
C2390	W Ovechkin	VWDKFYHC2@verizon.com
C2391	K Pitkanen	KVFZFJHJ3@comcast.com
C2392	E Iginla	PQYSCDGX1@gmail.com
C2393	H Zhitnik	YDIMTFCN1@gmail.com
C2394	R Lidstrom	APAFWKIF2@verizon.com
C2395	H Crosby	NLRFXUMZ1@gmail.com
C2396	T Zetterberg	SZUIBOSV3@comcast.com
C2397	X Phaneuf	JUUDNBVX2@verizon.com
C2398	A Knuble	NWOHIQOS1@gmail.com
C2399	X Kovalev	BTIDZDCV3@comcast.com
C2400	G Williams	CDBLLWRS1@gmail.com
C2401	F Gonchar	YTCBKMCK1@gmail.com
C2402	T Prospal	CIFVFYHA2@verizon.com
C2403	V Modano	WNSSEDCM1@gmail.com
C2404	C Datsyuk	AIEASDBE1@gmail.com
C2405	S Lemieux	GEDBZKKG1@gmail.com
C2406	N Samsonov	IMLKDANM2@verizon.com
C2407	F Cole	AAKFIYFX3@comcast.com
C2408	J Rolston	OKHTTNMG1@gmail.com
C2409	K Boucher	ASJIFLHU2@verizon.com
C2410	Y Esche	AOFREJHY1@gmail.com
C2411	L Yashin	TZSBFZJN1@gmail.com
C2412	A Koivu	ZOVZMEZN3@comcast.com
C2413	B Turco	KQSKXIWT2@verizon.com
C2414	Q Arnott	YCDUESBE3@comcast.com
C2415	V Thornton	YOGQZCNE2@verizon.com
C2416	G Desjardins	AGPIJWKI2@verizon.com
C2417	Q Brind'Amour	WLYHMSPK1@gmail.com
C2418	B Spacek	UHBRPUOQ1@gmail.com
C2419	W Holmstrom	XJRQZAOI3@comcast.com
C2420	X Richards	ZBLSMMAM1@gmail.com
C2421	R Niedermayer	IIYBGWFI3@comcast.com
C2422	S Bondra	MKFWIVJQ1@gmail.com
C2423	G Guerin	CDGFNQJQ2@verizon.com
C2424	N Recchi	XPZVWILH3@comcast.com
C2425	L Grahame	ZZALBGBV3@comcast.com
C2426	U Briere	UWYAJWAF3@comcast.com
C2427	K Morrow	BDHANAWK3@comcast.com
C2428	Z Kovalchuk	ZWJXVENV2@verizon.com
C2429	X Slegr	FYWPRGUY3@comcast.com
C2430	V Stillman	SQEIYDZY1@gmail.com
C2431	L Hamrlik	YWPOPJJU1@gmail.com
C2432	G Vorobiev	HJBGKILI3@comcast.com
C2433	E Lupul	RLJZLIZU2@verizon.com
C2434	O DeVries	NLFKDKLF2@verizon.com
C2435	T Berard	RNVEIIRC2@verizon.com
C2436	D Young	CKEZQYXW2@verizon.com
C2437	D Stoll	RXORIULO2@verizon.com
C2438	C Gionta	UKSEHIRB3@comcast.com
C2439	N Hemsky	VCPNVIOO1@gmail.com
C2440	R Lindros	AVEDAJQL2@verizon.com
C2441	C Blake	PHPCABYM2@verizon.com
C2442	H Osgood	HFEOGZYE3@comcast.com
C2443	R Savard	GSTDXIIV1@gmail.com
C2444	S Brisebois	SDSFDSAI1@gmail.com
C2445	Z Seabrook	YUVOZKGT2@verizon.com
C2446	P Lang	VWAKITMJ3@comcast.com
C2447	H Jackman	URWBQIHG1@gmail.com
C2448	R Laperriere	WCRODSDA2@verizon.com
C2449	G Sykora	FDVLVYZW3@comcast.com
C2450	X Jokinen	IBHUXPGO3@comcast.com
C2451	Z Neil	ERNWNOMT2@verizon.com
C2452	R Ohlund	CWIUKKZC2@verizon.com
C2453	F Rucinsky	SDHDUTVO1@gmail.com
C2454	O Amonte	EGDDHXIG2@verizon.com
C2455	R Doan	OOODFOGH1@gmail.com
C2456	K Bertuzzi	RTJRGDNI3@comcast.com
C2457	Y Frolov	WBUMWMWO1@gmail.com
C2458	O Conroy	YZWIPRDM1@gmail.com
C2459	U Ward	NQTXGRDU1@gmail.com
C2460	M Lehtinen	FZNNKWZD1@gmail.com
C2461	O Marleau	YKUXOLBN3@comcast.com
C2462	L Palffy	GGGYQKXW1@gmail.com
C2463	V Smyth	KBQTUORZ1@gmail.com
C2464	H Zubov	PUDEUQGG2@verizon.com
C2465	V Straka	NNAHBWGB3@comcast.com
C2466	Y Avery	JFRDFTDH3@comcast.com
C2467	M Samuelsson	QRAUSBLJ1@gmail.com
C2468	K Van	WUBBSZHX1@gmail.com
C2469	T Eminger	LBWNPYPD2@verizon.com
C2470	Y Torres	OOWBINLP1@gmail.com
C2471	H Arnason	KDITELDJ3@comcast.com
C2472	K McDonald	FGJHCSRT2@verizon.com
C2473	H Horton	YKQEMYTU1@gmail.com
C2474	K Aebischer	AJSINUKR2@verizon.com
C2475	I Sullivan	VVSZPHDX2@verizon.com
C2476	U Burke	UFZDXEDC1@gmail.com
C2477	Q Prusek	AMGJBRWN3@comcast.com
C2478	V Satan	FISCMWFM3@comcast.com
C2479	R Horcoff	AOVBATTS2@verizon.com
C2480	X Allison	FXZDOAJA3@comcast.com
C2481	I Afinogenov	HNUTRSWC2@verizon.com
C2482	Q Fischer	RYQTXBFF2@verizon.com
C2483	C Bergeron	BKYNVWTS1@gmail.com
C2484	M Leetch	VKUPDYCC1@gmail.com
C2485	S Modin	WGVQDPKZ1@gmail.com
C2486	B Cheechoo	YTNYYVJY2@verizon.com
C2487	R Leclerc	MRVXWRSI1@gmail.com
C2488	E Nagy	ULWVKEQH2@verizon.com
C2489	F Bouchard	TBIFMBXW3@comcast.com
C2490	U Modry	BZQTFREB1@gmail.com
C2491	Y Toivonen	XEAVNJRT1@gmail.com
C2492	H Kotalik	AIPLHLWI2@verizon.com
C2493	J Begin	ZNTKOSLJ2@verizon.com
C2494	Z Nylander	VKAVNYXG2@verizon.com
C2495	O Kariya	LALXUKVJ1@gmail.com
C2496	J Steen	KCRRIBTT3@comcast.com
C2497	I Emery	SFMNEPLO1@gmail.com
C2498	Y Blake	LHETLKDR2@verizon.com
C2499	H Kozlov	JDHMWXWU3@comcast.com
C2500	G O'Neill	IODVODRX3@comcast.com
C2501	C Cullen	EHWFGUWF3@comcast.com
C2502	K Moreau	AKKUINLH3@comcast.com
C2503	H Sedin	TBKFUUAN2@verizon.com
C2504	H Ribeiro	PZHDQPSK3@comcast.com
C2505	T St.	JHEASZPE1@gmail.com
C2506	U Staios	POWKMGOI2@verizon.com
C2507	K Morrison	STEUKJNT3@comcast.com
C2508	L Carney	LIAOJETI2@verizon.com
C2509	L Mogilny	CLQAWGYF2@verizon.com
C2510	M Langkow	ECEUOGUO2@verizon.com
C2511	Q Brown	IDRBTYVA3@comcast.com
C2512	X Kolzig	PKJCSHQZ2@verizon.com
C2513	B Sakic	SHBWWMDK2@verizon.com
C2514	N Scatchard	OUYEIFTQ1@gmail.com
C2515	I Tucker	GPBHIRVU1@gmail.com
C2516	Q Richards	OQGXVGWR1@gmail.com
C2517	P Ryder	GYVCZVAT2@verizon.com
C2518	Y Svatos	UZSPURWV3@comcast.com
C2519	B Lapointe	NNOCCNIB2@verizon.com
C2520	H Axelsson	QEKEGZMI3@comcast.com
C2521	K Sturm	JCLEOFBO3@comcast.com
C2522	P Timonen	BSYCDDOV3@comcast.com
C2523	S Rathje	ZOVOJBOM2@verizon.com
C2524	H Niedermayer	GGREIQAM3@comcast.com
C2525	J Handzus	KIRBRTNC3@comcast.com
C2526	H Cajanek	UQSFTUTC2@verizon.com
C2527	O Ott	KNIXGNBS1@gmail.com
C2528	P Belfour	NXQHVQLS3@comcast.com
C2529	S Bergeron	QOSNJXCM2@verizon.com
C2530	C Markov	COSHJCEQ3@comcast.com
C2531	B Comrie	OMPXHVKN2@verizon.com
C2532	X Sedin	IGKGCCOO3@comcast.com
C2533	I Kubina	JKDZIJFX2@verizon.com
C2534	V Dunham	TFVHUHPZ1@gmail.com
C2535	R Kaberle	WPFVROCU3@comcast.com
C2536	L Langenbrunner	VLSVGGFJ3@comcast.com
C2537	R Schaefer	JPBWPEQA3@comcast.com
C2538	H Havlat	KWVJFFPJ3@comcast.com
C2539	U Whitney	VGJHVBRA2@verizon.com
C2540	D McLaren	AKLMNDXV2@verizon.com
C2541	C Chouinard	KNGLHPMO2@verizon.com
C2542	B Stevenson	CNPQMYJQ2@verizon.com
C2543	N Tverdovsky	CDHPRCOK3@comcast.com
C2544	R Stuart	QSZDWKBZ1@gmail.com
C2545	N Johnsson	PGBPHDYA2@verizon.com
C2546	H Hartnell	MCSAZWII1@gmail.com
C2547	A Boyle	YSLIQGTH2@verizon.com
C2548	G Robitaille	FDSWLUOS2@verizon.com
C2549	E Turgeon	GLXKQOGQ3@comcast.com
C2550	V Weight	DINQUVTB3@comcast.com
C2551	H Kobasew	WFHTNITO1@gmail.com
C2552	R Green	IXUTZCQZ2@verizon.com
C2553	P Tjutin	HDSOBFTA1@gmail.com
C2554	P McCarty	XIYHWMAD1@gmail.com
C2555	I Michalek	XDJCINYP2@verizon.com
C2556	G Wellwood	XFPDHBTM1@gmail.com
C2557	N Dumont	QWSEROID2@verizon.com
C2558	X Salei	PLBSZXIP1@gmail.com
C2559	R Budaj	KKKJANOT3@comcast.com
C2560	F Nash	LXDCUQQC1@gmail.com
C2561	L White	SPRZJLOG3@comcast.com
C2562	Q Vanek	REGZHJUR3@comcast.com
C2563	E Rozsival	RXYZUAFI3@comcast.com
C2564	G Laaksonen	QGRTARWZ3@comcast.com
C2565	P Mayers	SRODHSOU3@comcast.com
C2566	E Tanguay	MKQIYIJP3@comcast.com
C2567	O Yelle	HNOTRPQX3@comcast.com
C2568	L LeClair	LMZDOJZY3@comcast.com
C2569	K Saprykin	MURQKYYN2@verizon.com
C2570	W Brewer	BXPIYFUM1@gmail.com
C2571	U McLennan	XUUPWKBX2@verizon.com
C2572	J Danis	AWBGOBTJ3@comcast.com
C2573	N Jokinen	HURYKIXK3@comcast.com
C2574	T Parros	WVQMIOXZ2@verizon.com
C2575	A Brunette	ZSGWHGCJ1@gmail.com
C2576	W Ballard	NRSDHEWK1@gmail.com
C2577	H Weekes	IBRKUBNF1@gmail.com
C2578	O Vyborny	XBQMRZXA2@verizon.com
C2579	F Cloutier	QZUHORGM1@gmail.com
C2580	V Sillinger	NWJOMJXL2@verizon.com
C2581	M Chelios	TRDOXKZO1@gmail.com
C2582	N Sanderson	LHBUFRWE3@comcast.com
C2583	Y Perezhogin	YTCCFMZY2@verizon.com
C2584	Q Klee	GTATDAXO3@comcast.com
C2585	D Cammalleri	ECMMUOMC3@comcast.com
C2586	X Legwand	HBFXCNZH3@comcast.com
C2587	A Brown	SMWEGNTW3@comcast.com
C2588	Z Marchant	HYBTFWGS2@verizon.com
C2589	L Phillips	WVBSQFDA1@gmail.com
C2590	A Asham	WJDKBMZC3@comcast.com
C2591	M Ference	UIMQNFRV2@verizon.com
C2592	Q Kaberle	DASJUTFC2@verizon.com
C2593	S Hecht	MOZTIOKZ2@verizon.com
C2594	E Carter	XLCMUWEG1@gmail.com
C2595	D Fedoruk	VNNEDMXT2@verizon.com
C2596	J Hill	POVACRDQ1@gmail.com
C2597	B Raycroft	MCMSKFKL2@verizon.com
C2598	R Meszaros	JUABJFUG3@comcast.com
C2599	R Boyes	MCLTCYLZ3@comcast.com
C2600	H Stajan	ZHTKFCUN1@gmail.com
C2601	T Kozlov	SVEFRZBZ2@verizon.com
C2602	A Kuba	CBTAGZXR1@gmail.com
C2603	E Pronger	AZHMMBFC1@gmail.com
C2604	X Muir	MFNYHDXJ1@gmail.com
C2605	P Clemmensen	QJPRUEKX3@comcast.com
C2606	H Foote	FGVRGKGL2@verizon.com
C2607	H Weiss	YFZKWLMY1@gmail.com
C2608	J Bell	BPOWGCTB2@verizon.com
C2609	V Andreychuk	FBFUTCPG3@comcast.com
C2610	Y Konowalchuk	QVAKBVIJ3@comcast.com
C2611	B Corvo	FYHKVHHX1@gmail.com
C2612	Y Belanger	JPNKGEYY1@gmail.com
C2613	T Hamhuis	GDHERTVJ2@verizon.com
C2614	P Reinprecht	LBBZCDLG1@gmail.com
C2615	H Roenick	RJHAMXQP1@gmail.com
C2616	N Berkhoel	AZRXYILF3@comcast.com
C2617	J Halpern	XJZEDBUE3@comcast.com
C2618	J Robitaille	ZSHJACYG3@comcast.com
C2619	Y Snow	TQMVELYE3@comcast.com
C2620	O Boynton	MKXVVICS3@comcast.com
C2621	P Michalek	UKEPTOSI3@comcast.com
C2622	M Leneveu	TTYRUSHO1@gmail.com
C2623	A Barnaby	YIWWQPOD1@gmail.com
C2624	S Gleason	XBICIMSC3@comcast.com
C2625	L Hossa	HTVNJXNV1@gmail.com
C2626	F Backman	XSUOWFVF1@gmail.com
C2627	X Smith	PONBOTKL2@verizon.com
C2628	W Brylin	ZEHBQNHG2@verizon.com
C2629	I Gelinas	DNDGCJJG3@comcast.com
C2630	L Caron	ADCWFHKV1@gmail.com
C2631	J Mason	NCIZONHL2@verizon.com
C2632	F Rafalski	JGQCNRBK2@verizon.com
C2633	K Malhotra	AQMIXJDF2@verizon.com
C2634	L Lehtonen	QLFPIQRM3@comcast.com
C2635	M Clark	FRUSHBQR1@gmail.com
C2636	P Williams	MFHSZXIB3@comcast.com
C2637	J Sim	LQNPIHWL1@gmail.com
C2638	P Krajicek	AGYNARFU2@verizon.com
C2639	S Goc	UXFYRSGM3@comcast.com
C2640	I Bourque	FCVOZDWW2@verizon.com
C2641	Q Hatcher	ZSVAFEZR1@gmail.com
C2642	B Zyuzin	EYCWNEXW1@gmail.com
C2643	O Boogaard	ZPABEQBP3@comcast.com
C2644	P Skoula	IPGSRQSK1@gmail.com
C2645	K Erat	WGXQTMIB3@comcast.com
C2646	O Heward	RUPNUVSP1@gmail.com
C2647	W Kasparaitis	YSYPMXHQ1@gmail.com
C2648	N Getzlaf	HRSFXTNP3@comcast.com
C2649	K Baumgartner	BTKHIGEM2@verizon.com
C2650	B Holik	OBQMXQFQ2@verizon.com
C2651	B Lilja	NCUWRVOK3@comcast.com
C2652	S Bryzgalov	ZYYKTJXY2@verizon.com
C2653	X Brodeur	LJDPBUBU1@gmail.com
C2654	H Orpik	AMTVAHDM2@verizon.com
C2655	C Kostopoulos	MRXKKBSR1@gmail.com
C2656	R Boulton	HRHHCLDH1@gmail.com
C2657	E Barnes	TKDZZIPX1@gmail.com
C2658	L Bouillon	RRZNSBUE1@gmail.com
C2659	A Fedotenko	MRRCVKYV2@verizon.com
C2660	M Rivet	ESSPEFPM2@verizon.com
C2661	K Daigle	BAUBNURM3@comcast.com
C2662	B Domi	EZNASLLU2@verizon.com
C2663	N Weinrich	JXRJVZUG3@comcast.com
C2664	F Miettinen	XZMNTHFE1@gmail.com
C2665	N Kolnik	XOFRIXTV1@gmail.com
C2666	T Souray	EUEOGWMD2@verizon.com
C2667	R Gomez	SZICMOLL1@gmail.com
C2668	C Malone	OORTCFMA1@gmail.com
C2669	E Armstrong	QQHKMUSK2@verizon.com
C2670	N Tellqvist	QOKOIUJA2@verizon.com
C2671	S McAmmond	AMGULKLA3@comcast.com
C2672	H Daley	CVRGDTPS1@gmail.com
C2673	T Hedican	CFLFJYZH2@verizon.com
C2674	T Bulis	KYDIPHOW1@gmail.com
C2675	P Goren	ENXWCXFY1@gmail.com
C2676	J Devereaux	QFJULJPT2@verizon.com
C2677	C Nilson	PWFEBNHI1@gmail.com
C2678	T Smith	XBNZPLPX1@gmail.com
C2679	D Zherdev	HSCCFVQM2@verizon.com
C2680	M Johnson	SZUZQVQY1@gmail.com
C2681	Q Dvorak	RCLLCFMR1@gmail.com
C2682	K Gaustad	YDRYYTDM2@verizon.com
C2683	J Numminen	BWFGTHQV3@comcast.com
C2684	V Garon	WAAASMSS2@verizon.com
C2685	A Connolly	POATYXUA3@comcast.com
C2686	H Vandermeer	VJRIUTHK2@verizon.com
C2687	S Poti	DIXXCNEG2@verizon.com
C2688	U Perreault	MTWHZSMQ1@gmail.com
C2689	R Smolinski	TWQVFIRW1@gmail.com
C2690	H Walz	DFXLLJDO1@gmail.com
C2691	R Parrish	WWYKVQTB3@comcast.com
C2692	S Sauve	LHFPWEBY2@verizon.com
C2693	B Park	KFZRUJRS2@verizon.com
C2694	W Ponikarovsky	BBIZHZPD2@verizon.com
C2695	U Clark	WPUFGNYJ2@verizon.com
C2696	S Martin	KYYKGPBR1@gmail.com
C2697	P Rucchin	ZUZZMAOX2@verizon.com
C2698	P Pisani	GFWNPODL3@comcast.com
C2699	D Reasoner	RWCQWLEP1@gmail.com
C2700	C Vermette	HQRUDSDH2@verizon.com
C2701	K Mezei	HYQUHGER1@gmail.com
C2702	W Brown	PVXMRXWO3@comcast.com
C2703	K Peca	NKNANJKQ2@verizon.com
C2704	B DiPietro	RFDMQUPD2@verizon.com
C2705	X McGrattan	ROSLULCC1@gmail.com
C2706	H Ellison	ZPGCVSRB3@comcast.com
C2707	C Burns	VMQYKGOH2@verizon.com
C2708	K Dupuis	ENPNZMPY2@verizon.com
C2709	B Wanvig	LKAYDWOI1@gmail.com
C2710	V Stefan	XBZKYQKD3@comcast.com
C2711	R Ruutu	ABRKIIHO2@verizon.com
C2712	E Madden	YJYFDPTB3@comcast.com
C2713	Z Bouwmeester	CJKXSVGT1@gmail.com
C2714	Q Tarnstrom	MBAVXLMB2@verizon.com
C2715	K Dimitrakos	CUWJKIST3@comcast.com
C2716	K Moore	JNSXUDZT3@comcast.com
C2717	H Zubrus	KPQIEHGQ3@comcast.com
C2718	P Nieminen	HUSFXEIQ2@verizon.com
C2719	H McCauley	PUVZLBJB2@verizon.com
C2720	O Plekanec	LEZORWCY2@verizon.com
C2721	N Hedstrom	KIBDWIDC2@verizon.com
C2722	A Primeau	MWKENJEU2@verizon.com
C2723	K Vasicek	PGTCFWBD2@verizon.com
C2724	W Calder	HOHTZYTQ1@gmail.com
C2725	K Malik	IZPBMDCR3@comcast.com
C2726	K Nedved	XWWSMGSL1@gmail.com
C2727	N Sundstrom	RTAATWFD3@comcast.com
C2728	D Pothier	CXEWFPBP1@gmail.com
C2729	G Kvasha	TWHHREVT2@verizon.com
C2730	U Brashear	JEXXTXPN1@gmail.com
C2731	X Malakhov	JGOATMDE2@verizon.com
C2732	V Pahlsson	IACIBSTW3@comcast.com
C2733	Y Morris	VJPYIEQW1@gmail.com
C2734	R Leahy	NRCEVIZM2@verizon.com
C2735	N Niinimaa	CNSHOFRM1@gmail.com
C2736	A Wesley	OQHSTOCM1@gmail.com
C2737	U Brennan	UQPJWNRG1@gmail.com
C2738	Y Chimera	DKWYMLHC1@gmail.com
C2739	S Higgins	HRWQHTMT2@verizon.com
C2740	Q Nabokov	RIHWEILL2@verizon.com
C2741	U Hejduk	YUVWMRQP1@gmail.com
C2742	O Campoli	PEWVZZVH3@comcast.com
C2743	M Lydman	JPAVCJDP2@verizon.com
C2744	Z Dandenault	YUWZIXBI1@gmail.com
C2745	T Wiemer	UWEAAGRZ3@comcast.com
C2746	K Carter	GSAHFPUC3@comcast.com
C2747	R Hedberg	HGVGFTGK2@verizon.com
C2748	J Hunter	BJWKRBXJ1@gmail.com
C2749	U Cooke	CNDIFENT3@comcast.com
C2750	O Shelley	WOFIBYOI3@comcast.com
C2751	Y Parise	GDSQHEDL1@gmail.com
C2752	B Zidlicky	MEJOTIOV2@verizon.com
C2753	D Huselius	VJYZAXMC3@comcast.com
C2754	U Khavanov	ZJXQXEKN1@gmail.com
C2755	H Warrener	YTYHAOFR3@comcast.com
C2756	Z Zednik	ZJXRKCKB3@comcast.com
C2757	S Leclaire	NTIJCDCX3@comcast.com
C2758	T Ward	KPOTTQSG1@gmail.com
C2759	A Whitney	EDUROGOF1@gmail.com
C2760	B Gratton	BXGIKRXP2@verizon.com
C2761	A Bochenski	AZPGFBBF3@comcast.com
C2762	F Petrovicky	RSCOOOLN2@verizon.com
C2763	Q Suter	OWBWSORI1@gmail.com
C2764	I Fisher	ZUZOSBPR1@gmail.com
C2765	T Hrdina	KGTFANNL1@gmail.com
C2766	X McLean	TFYYUJNY1@gmail.com
C2767	Y Sarich	HBJOJRRM2@verizon.com
C2768	A Fitzpatrick	BORBYNAH2@verizon.com
C2769	B Cross	UPXULTVG3@comcast.com
C2770	Y York	PQRXFGVL3@comcast.com
C2771	C Mitchell	MQIWETTS1@gmail.com
C2772	F Fitzgerald	GACQEFUQ3@comcast.com
C2773	Y Aucoin	QNDUEJBL1@gmail.com
C2774	Q Cullimore	RMWWFPPZ3@comcast.com
C2775	K McGillis	XRUMHWCM3@comcast.com
C2776	Z Donovan	EDYPLITC1@gmail.com
C2777	F Thornton	OUAZLDZU2@verizon.com
C2778	X Maltby	NTGFAWBK3@comcast.com
C2779	J May	XTGHFVDH3@comcast.com
C2780	L Perry	NRACRMGL3@comcast.com
C2781	A Commodore	MDTVZEKG1@gmail.com
C2782	N Nieuwendyk	USNIPOFY3@comcast.com
C2783	Y Bates	NXSKYJCZ2@verizon.com
C2784	G Isbister	GWRUZCYR2@verizon.com
C2785	L Nichol	JHCIKUCH1@gmail.com
C2786	U Kesler	LQFNGGLP3@comcast.com
C2787	Q Gaborik	MZSGIZAA2@verizon.com
C2788	A VandenBussche	GZQDGLPQ2@verizon.com
C2789	Y Drury	ZJQLZEDV3@comcast.com
C2790	J Fleury	EOAEQWUL1@gmail.com
C2791	P Willsie	QZPBDGFV3@comcast.com
C2792	H Letowski	GLSWPTZD2@verizon.com
C2793	L Cleary	UCRCKDBB3@comcast.com
C2794	D Vishnevski	SFBUGGNR3@comcast.com
C2795	W Preissing	KAYARXTK3@comcast.com
C2796	D Sopel	BZBNNGYH3@comcast.com
C2797	V Primeau	TPFTEPYZ2@verizon.com
C2798	A Ekman	TSKXADLQ2@verizon.com
C2799	Z Foy	ASXGZETO1@gmail.com
C2800	D Pirjeta	FQYVTJHL3@comcast.com
C2801	D Kapanen	VUGLTJRK3@comcast.com
C2802	D Aubin	KNPCZGNK1@gmail.com
C2803	L Radivojevic	AGJOGUWI3@comcast.com
C2804	L Wright	YPTXUEOR2@verizon.com
C2805	B Simon	YEBWAKKZ3@comcast.com
C2806	F Wolski	MZPNDDGG2@verizon.com
C2807	T Denis	JEHXIVTN2@verizon.com
C2808	E Noronen	JBPUAVFZ1@gmail.com
C2809	P Garnett	DXWMKYLC1@gmail.com
C2810	E Kilger	JBVJGMXU2@verizon.com
C2811	W Betts	LKTISQDZ2@verizon.com
C2812	R Dowd	BFBCNTYS2@verizon.com
C2813	Q Hordichuk	YLJJNSLA3@comcast.com
C2814	Z Sutton	OQEIYNDS2@verizon.com
C2815	W Kelly	FZGHRGGA3@comcast.com
C2816	E Dagenais	NVMVQSCX1@gmail.com
C2817	L Havelid	QWGEJABM3@comcast.com
C2818	S Drake	HKQNWLTI2@verizon.com
C2819	T Niittymaki	WKSWFPQJ1@gmail.com
C2820	S Robidas	JTTIFVJV3@comcast.com
C2821	D Volchenkov	LJXLLQWW3@comcast.com
C2822	I Draper	XJIZYAXU1@gmail.com
C2823	E Downey	ZXADHACO2@verizon.com
C2824	J Nordgren	OQBNQVUJ1@gmail.com
C2825	G Woolley	KRNPPJJH1@gmail.com
C2826	X Walker	UHFHPKET3@comcast.com
C2827	E Nilsson	PJCMRGLC3@comcast.com
C2828	E Marshall	JBUDSVLN2@verizon.com
C2829	V Talbot	EFVMUOBQ3@comcast.com
C2830	U McClement	DVOXOSCF2@verizon.com
C2831	V Sharp	GVJAJWWI3@comcast.com
C2832	J Davison	ASHXXQVV2@verizon.com
C2833	B Kolanos	TPMWABBD3@comcast.com
C2834	H Johnson	NJAUZRNL1@gmail.com
C2835	C Allen	QUHNCUNX3@comcast.com
C2836	H Markov	QMRTKZAO2@verizon.com
C2837	Z Hoggan	GCOYEYKR2@verizon.com
C2838	W Antropov	CMCIHENK1@gmail.com
C2839	D Hall	EVDSXULC2@verizon.com
C2840	S Franzen	USFTSEKO1@gmail.com
C2841	N Laraque	OOXJBEKS3@comcast.com
C2842	Z Simpson	FBFRZDOS3@comcast.com
C2843	M Prucha	VWNXZGGP2@verizon.com
C2844	U Vaananen	DGEIMIQC1@gmail.com
C2845	L Dallman	YBPVNECQ3@comcast.com
C2846	B Jackman	JHOABPGZ3@comcast.com
C2847	B Ruutu	ZMZVGEJS1@gmail.com
C2848	C Witt	KSCEBGMY2@verizon.com
C2849	D Roach	OLDXPFWG1@gmail.com
C2850	O Conklin	DHIFZSBY3@comcast.com
C2851	B Gill	RQROENZI3@comcast.com
C2852	U Pandolfo	PGHHHEUD1@gmail.com
C2853	X Bonk	FIGHIDFM3@comcast.com
C2854	G Sydor	CWMZNZWQ3@comcast.com
C2855	N Rasmussen	OKEUMKDA3@comcast.com
C2856	B Hollweg	UPUNNYFI3@comcast.com
C2857	K Orr	QIWOLLMR3@comcast.com
C2858	R Ritchie	HQFZPVSK1@gmail.com
C2859	S Henry	RQFFLDTW1@gmail.com
C2860	B Savage	IQZNRDNZ1@gmail.com
C2861	Z Ortmeyer	NOAMXCIB1@gmail.com
C2862	U Sykora	KEPRKLYP1@gmail.com
C2863	I Gillies	XMWFMHGJ3@comcast.com
C2864	K Clowe	PLVQOGCD1@gmail.com
C2865	R Godard	BFNTIUTQ1@gmail.com
C2866	W Mellanby	BZPLMBMZ3@comcast.com
C2867	B Hannan	JDYPBZUQ2@verizon.com
C2868	A Stumpel	NUVPNWVQ3@comcast.com
C2869	W Christensen	EQGSUWFS3@comcast.com
C2870	X Ricci	CZMVFCMJ2@verizon.com
C2871	A Exelby	DLGRVBPT2@verizon.com
C2872	B Sundin	JSJXLGII2@verizon.com
C2873	D Moen	TBUVKWEF1@gmail.com
C2874	Q Holmqvist	WDNTTGFD1@gmail.com
C2875	N Erskine	ZSZASJXZ2@verizon.com
C2876	F Belak	TZXDJKVD3@comcast.com
C2877	E Campbell	DCCKUULE3@comcast.com
C2878	S Kalinin	HHARPPYJ3@comcast.com
C2879	X Andersson	VZOPNSKH3@comcast.com
C2880	J Lebda	JNCJWRIN3@comcast.com
C2881	O Olesz	XQBHGOHF3@comcast.com
C2882	A Brookbank	JZJNJSQG3@comcast.com
C2883	Q Linden	PRLOOKSH1@gmail.com
C2884	L Klemm	XFSYUCWD1@gmail.com
C2885	R Vrbata	XDOUFTRC3@comcast.com
C2886	B Biron	GFODDBGT3@comcast.com
C2887	P Lukowich	LVVHIOXC1@gmail.com
C2888	F Langfeld	AGYHFXUO1@gmail.com
C2889	M Lessard	VBQNREMW1@gmail.com
C2890	O Kwiatkowski	EBYCXETN1@gmail.com
C2891	S Payer	AHNDIEKD3@comcast.com
C2892	B Komisarek	WLLFOEGL2@verizon.com
C2893	S Adams	SPXQHRQS1@gmail.com
C2894	Y Biron	HZCXFULO2@verizon.com
C2895	N Bradley	NLLNXHNB3@comcast.com
C2896	H Harvey	LGEIXTSO3@comcast.com
C2897	Q Veilleux	OBUHAOZU3@comcast.com
C2898	O Sjostrom	GOBMYIPC3@comcast.com
C2899	N Roberts	USWLFUQG3@comcast.com
C2900	F Friesen	FDAOSLNN3@comcast.com
C2901	Y Shields	HONKRUBB2@verizon.com
C2902	F Taylor	ULOHDIXK2@verizon.com
C2903	Y Marshall	DQYMXMOP2@verizon.com
C2904	A McCarthy	WVUDWEAB1@gmail.com
C2905	L Mowers	MTSJWJIT3@comcast.com
C2906	P Morgan	FHTWGFQJ2@verizon.com
C2907	Q Wilm	IDQRCVTT3@comcast.com
C2908	B Rita	QGYCNYYQ3@comcast.com
C2909	I Nokelainen	ETQFTPTY1@gmail.com
C2910	Q Stewart	VULRMVOY2@verizon.com
C2911	V Hartigan	OVVKAXNW1@gmail.com
C2912	K Keith	NQCKOLCF1@gmail.com
C2913	P Koltsov	OUBWVQQQ3@comcast.com
C2914	O Semenov	CFEDXKDM2@verizon.com
C2915	H Grier	LQTYXRVC2@verizon.com
C2916	A Sauer	WSPGRPHE2@verizon.com
C2917	G Berg	GHVLKZND3@comcast.com
C2918	I Ward	FEYMZUOD2@verizon.com
C2919	Z Moran	OSGRAUOS2@verizon.com
C2920	R Murley	SKZNDWTK2@verizon.com
C2921	N Montador	BOSXIIGQ3@comcast.com
C2922	B Leopold	SJHJCAYU3@comcast.com
C2923	W Healey	TARVZXCG3@comcast.com
C2924	R Kunitz	YAROKQFN3@comcast.com
C2925	L Lombardi	ACABTSKK2@verizon.com
C2926	F Norstrom	YCPIVXCC2@verizon.com
C2927	K Yzerman	FRZLDVYL2@verizon.com
C2928	R Mair	BLHDDKHJ3@comcast.com
C2929	F Pettinger	MPUJSWKB3@comcast.com
C2930	Y DiPenta	HQNGSVLM1@gmail.com
C2931	N Cassels	JKMUBZKI3@comcast.com
C2932	T Morrisonn	GFIBETSW1@gmail.com
C2933	D Schultz	TZLBYOYC2@verizon.com
C2934	I Strudwick	KABNECVS2@verizon.com
C2935	R Balastik	SHYGLOGU1@gmail.com
C2936	P Wallin	FRETYPKH1@gmail.com
C2937	F Alberts	QGZYFBVM1@gmail.com
C2938	C DiMaio	IOLITTRR1@gmail.com
C2939	P Fedorov	XEOQAZPU3@comcast.com
C2940	V Artyukhin	OXHHFVWK3@comcast.com
C2941	S O'Donnell	IGLIDRPJ1@gmail.com
C2942	H Stempniak	BFENHROZ1@gmail.com
C2943	V Fritsche	GOKMKFFA3@comcast.com
C2944	Y McEachern	ISVUMULM1@gmail.com
C2945	C Pyatt	FLRVJSXN3@comcast.com
C2946	O Rycroft	BQYONVGU2@verizon.com
C2947	B Allison	KGDQPOSS1@gmail.com
C2948	Y Beauchemin	EYWBMAXG3@comcast.com
C2949	U Klepis	ROPGQTJH1@gmail.com
C2950	Q Sejna	LHUPKMRI2@verizon.com
C2951	T McKee	CSFHXIVW2@verizon.com
C2952	J Poapst	PTDDNUHF1@gmail.com
C2953	Z Eaves	NWTVRNOZ1@gmail.com
C2954	U Vigier	XUYSACVP1@gmail.com
C2955	C Cowan	UFIYVFYG1@gmail.com
C2956	W Hagman	GNRYWZFM2@verizon.com
C2957	W Fata	LDJCIUIB2@verizon.com
C2958	G Afanasenkov	RXFHBHME1@gmail.com
C2959	Q Czerkawski	LMYMCYVO1@gmail.com
C2960	Z Boulerice	OAGFDUQN1@gmail.com
C2961	H Weinhandl	OOTHWZPF3@comcast.com
C2962	T Rupp	GSTVBTCM2@verizon.com
C2963	B Sutherby	LDCAERFC3@comcast.com
C2964	M Peters	MDHKPFXI2@verizon.com
C2965	K Toskala	SFFGPOVT3@comcast.com
C2966	Z Koivu	KQJJSTGO3@comcast.com
C2967	V Suchy	SNIDWXQR3@comcast.com
C2968	Z Miller	BSZKATZD3@comcast.com
C2969	V Skrastins	ZOXMRZQN3@comcast.com
C2970	C Tarnasky	USKWAQQO3@comcast.com
C2971	H Tanabe	QYRFITZI2@verizon.com
C2972	Y Clymer	HXPXLQOC1@gmail.com
C2973	O Hinote	HUBMWBKL2@verizon.com
C2974	Q Tallinder	JYHCJDKP3@comcast.com
C2975	C Fedorov	ACXBXZJW2@verizon.com
C2976	A Varada	TGDLKYIO2@verizon.com
C2977	Z Kondratiev	HWGJLIFC3@comcast.com
C2978	W MacDonald	YXVAEXIU1@gmail.com
C2979	I Zigomanis	MDWAZHMS3@comcast.com
C2980	S Richardson	RNUPJKDO1@gmail.com
C2981	R Johnson	BEJPLGZB1@gmail.com
C2982	D Upshall	VJRGMOXC2@verizon.com
C2983	N Winchester	RYSTYEVM2@verizon.com
C2984	B Konopka	ALAWQYIO3@comcast.com
C2985	V Laich	NZJXJIWD1@gmail.com
C2986	D Ehrhoff	JGMBUOSY3@comcast.com
C2987	C Roy	VHZAGOUU2@verizon.com
C2988	U Dempsey	VRZOKLVG2@verizon.com
C2989	M Matvichuk	DEAHCMMQ2@verizon.com
C2990	L Belanger	NTZCONZK1@gmail.com
C2991	C Ivanans	ZFBXDSVY2@verizon.com
C2992	S Ozolinsh	BERRFLWS2@verizon.com
C2993	V Goertzen	EZTYXXKS1@gmail.com
C2994	I Westcott	VTPTUAMG1@gmail.com
C2995	E Salvador	QXDZJRHF1@gmail.com
C2996	V Johnson	OXOKFCQN3@comcast.com
C2997	Y Stevenson	STTUSFNA2@verizon.com
C2998	F Dingman	BXBWOPSF1@gmail.com
C2999	C Pratt	FQYXJPIH3@comcast.com
C3000	Z Nazarov	WZGKTPBS1@gmail.com
C3001	W Martinek	CGSUNEVF2@verizon.com
C3002	X Hull	HHFCDEYE1@gmail.com
C3003	K Gauthier	BHMWPECC3@comcast.com
C3004	S Umberger	GSAODQXU1@gmail.com
C3005	M Svoboda	EISRIFQV3@comcast.com
C3006	O Larsen	BRJOXHHD3@comcast.com
C3007	X Ferguson	FCSVEHWR3@comcast.com
C3008	L Fleischmann	WXXUCEUH1@gmail.com
C3009	A Brule	LBZJFEYY1@gmail.com
C3010	S Gavey	SHSHAFJF1@gmail.com
C3011	T Lundmark	HDGONQFA2@verizon.com
C3012	C Hulse	WQRQGRBQ3@comcast.com
C3013	E Bernier	EHIITMGF3@comcast.com
C3014	F Streit	MJBUKBRX1@gmail.com
C3015	T Gordon	QTCBDYIC1@gmail.com
C3016	R Green	WZVNDZSG2@verizon.com
C3017	J Nash	OYCBBATA1@gmail.com
C3018	B Taffe	KZEWSLPZ3@comcast.com
C3019	W Marchment	WLBXTAPE3@comcast.com
C3020	V Klesla	NPBKPIEN3@comcast.com
C3021	J Slater	JDSJJNKH2@verizon.com
C3022	F Odelein	NQZNJFFN1@gmail.com
C3023	U Clarke	AACYSSHW2@verizon.com
C3024	C Whitfield	IGQRQOKH1@gmail.com
C3025	W Divis	VFXVJSUT2@verizon.com
C3026	N Tkachuk	EVKPFTXN3@comcast.com
C3027	N Tjarnqvist	PJHUDGWW2@verizon.com
C3028	Z Ulanov	OUJWXNDE2@verizon.com
C3029	H Barney	KZYDFYDP2@verizon.com
C3030	T Brodziak	AONSOHOJ1@gmail.com
C3031	H Janssen	PDGGXSYE3@comcast.com
C3032	Q Giuliano	TRHTWINS1@gmail.com
C3033	M Campbell	LGBYIFCO3@comcast.com
C3034	X Pominville	BFUJHODI1@gmail.com
C3035	S Nickulas	UXTZUENV2@verizon.com
C3036	H Roy	FRMGCUSY3@comcast.com
C3037	H Pihlman	EHRGILLR3@comcast.com
C3038	E Rheaume	ABFQENTV3@comcast.com
C3039	B Polak	HMNBOSDC3@comcast.com
C3040	P Bartovic	VCULWFBQ3@comcast.com
C3041	Z Eaton	YFMSKYOX1@gmail.com
C3042	X Peat	OPAJFTDU2@verizon.com
C3043	J Ranger	OCJFWCWP2@verizon.com
C3044	Z Boughner	OAKJOUBB3@comcast.com
C3045	J Gainey	GIEASLWX1@gmail.com
C3046	U Walker	LXWAJTGB1@gmail.com
C3047	F Fiddler	IKGZHYFC3@comcast.com
C3048	S Oliver	NNZOBNHZ2@verizon.com
C3049	G St.	DKHWXHTU2@verizon.com
C3050	I Cibak	WKJHCTWT3@comcast.com
C3051	T Daze	CFMHAULD3@comcast.com
C3052	V St.	INBOZUKH1@gmail.com
C3053	K Tootoo	ADOOUOQC1@gmail.com
C3054	H Fahey	EBYZWDCJ2@verizon.com
C3055	R Pettinen	VFSDGXPF3@comcast.com
C3056	S Melichar	NEPNTDKW1@gmail.com
C3057	F Hemingway	ABOGSYGS3@comcast.com
C3058	K Smith	YDLLSFKW2@verizon.com
C3059	X Coburn	XYDCMRBR1@gmail.com
C3060	E Oliwa	MXJHRBYF2@verizon.com
C3061	V Regehr	ODQPWPBZ2@verizon.com
C3062	Q Lessard	PQMFNYYU1@gmail.com
C3063	C Leach	FJAWALWF1@gmail.com
C3064	L Hnidy	JCODIONY2@verizon.com
C3065	U Gamache	QXQJENUI2@verizon.com
C3066	G Cairns	MCZSEMZX1@gmail.com
C3067	I Perrott	NOKIGWAM3@comcast.com
C3068	W Schubert	VUVLWURH1@gmail.com
C3069	L Woywitka	XLIQLVRY1@gmail.com
C3070	T Therien	FOENPPCR3@comcast.com
C3071	T Yonkman	CBKIEESH1@gmail.com
C3072	R Khabibulin	HFPAYYEH1@gmail.com
C3073	W White	ZZJXEZHI1@gmail.com
C3074	J Rivers	BSXQKHNE2@verizon.com
C3075	E Helbling	QLCSRQRH3@comcast.com
C3076	B Jurcina	WCXTAUUY3@comcast.com
C3077	C Weaver	YCLSVZLX2@verizon.com
C3078	A Tjarnqvist	MYTCMOQD3@comcast.com
C3079	S Syvret	HPZIBXQL3@comcast.com
C3080	E Karpovtsev	WLDTBEVM1@gmail.com
C3081	P Scuderi	WBKBKXGT3@comcast.com
C3082	I Green	ELQIBCML3@comcast.com
C3083	P Thibault	GWUBGSNC3@comcast.com
C3084	J Hutchinson	BQPWOKNI3@comcast.com
C3085	U Kloucek	ACOTXEMI3@comcast.com
C3086	W Jillson	BKYPCTSI1@gmail.com
C3087	Z Skolney	NFGNHPMB3@comcast.com
C3088	D Colaiacovo	RJTAMTLB3@comcast.com
C3089	G Delmore	HDGUJYUJ3@comcast.com
C3090	W Lampman	XZPXEJDS3@comcast.com
C3091	H Barker	JNYBRXSA2@verizon.com
C3092	A Kronwall	TVPCXPHW1@gmail.com
C3093	A Seidenberg	MTIYLNTK1@gmail.com
C3094	C Lalime	KFLFKOCR1@gmail.com
C3095	V Popovic	UJSDYIQR3@comcast.com
\.


--
-- Data for Name: sign_up_form; Type: TABLE DATA; Schema: public; Owner: liuyuwen_2018152068
--

COPY public.sign_up_form (sign_up_number, customer_number, deal_number) FROM stdin;
2	C2000	101
3	C2001	101
4	C2002	101
5	C2003	101
6	C2004	101
7	C2005	101
8	C2006	101
9	C2007	101
10	C2008	101
11	C2009	101
12	C2010	101
13	C2011	101
14	C2012	101
15	C2013	101
16	C2014	101
17	C2015	101
18	C2016	101
19	C2017	101
20	C2018	101
21	C2019	101
22	C2020	101
23	C2021	101
24	C2022	101
25	C2023	101
26	C2024	101
27	C2025	101
28	C2026	101
29	C2027	101
30	C2028	101
31	C2029	101
32	C2030	101
33	C2031	101
34	C2032	101
35	C2033	101
36	C2034	101
37	C2035	101
38	C2036	102
39	C2037	102
40	C2038	102
41	C2039	102
42	C2040	102
43	C2041	102
44	C2042	102
45	C2043	102
46	C2044	102
47	C2045	102
48	C2046	102
49	C2047	102
50	C2048	102
51	C2049	102
52	C2050	102
53	C2051	103
54	C2052	103
55	C2053	103
56	C2054	103
57	C2055	103
58	C2056	103
59	C2057	103
60	C2058	103
61	C2059	103
62	C2060	103
63	C2061	103
64	C2062	103
65	C2063	103
66	C2064	103
67	C2065	103
68	C2066	103
69	C2067	103
70	C2068	103
71	C2069	103
72	C2070	103
73	C2071	103
74	C2072	103
75	C2073	103
76	C2074	103
77	C2075	103
78	C2076	103
79	C2077	103
80	C2078	103
81	C2079	103
82	C2080	103
83	C2081	103
84	C2082	103
85	C2083	103
86	C2084	103
87	C2085	103
88	C2086	103
89	C2087	103
90	C2088	103
91	C2089	103
92	C2090	103
93	C2091	103
94	C2092	103
95	C2093	103
96	C2094	103
97	C2095	103
98	C2096	103
99	C2097	103
100	C2098	103
101	C2099	103
102	C2100	103
103	C2101	103
104	C2102	103
105	C2103	103
106	C2104	103
107	C2105	103
108	C2106	103
109	C2107	103
110	C2108	103
111	C2109	103
112	C2110	103
113	C2111	103
114	C2112	103
115	C2113	103
116	C2114	103
117	C2115	103
118	C2116	103
119	C2117	103
120	C2118	103
121	C2119	103
122	C2120	103
123	C2121	103
124	C2122	103
125	C2123	103
126	C2124	103
127	C2125	103
128	C2126	103
129	C2127	103
130	C2128	103
131	C2129	103
132	C2130	103
133	C2131	103
134	C2132	104
135	C2133	104
136	C2134	104
137	C2135	104
138	C2136	104
139	C2137	104
140	C2138	104
141	C2139	104
142	C2140	104
143	C2141	104
144	C2142	104
145	C2143	104
146	C2144	104
147	C2145	104
148	C2146	104
149	C2147	104
150	C2148	104
151	C2149	104
152	C2150	104
153	C2151	104
154	C2152	104
155	C2153	104
156	C2154	104
157	C2155	104
158	C2156	104
159	C2157	104
160	C2158	104
161	C2159	104
162	C2160	104
163	C2161	104
164	C2162	104
165	C2163	104
166	C2164	104
167	C2165	104
168	C2166	104
169	C2167	104
170	C2168	104
171	C2169	104
172	C2170	104
173	C2171	104
174	C2172	104
175	C2173	104
176	C2174	104
177	C2175	104
178	C2176	104
179	C2177	104
180	C2178	104
181	C2179	104
182	C2180	104
183	C2181	104
184	C2182	104
185	C2183	104
186	C2184	104
187	C2185	104
188	C2186	104
189	C2187	104
190	C2188	104
191	C2189	104
192	C2190	104
193	C2191	104
194	C2192	104
195	C2193	104
196	C2194	104
197	C2195	104
198	C2196	104
199	C2197	104
200	C2198	104
201	C2199	104
202	C2200	104
203	C2201	104
204	C2202	104
205	C2203	104
206	C2204	104
207	C2205	104
208	C2206	104
209	C2207	104
210	C2208	104
211	C2209	104
212	C2210	104
213	C2211	104
214	C2212	104
215	C2213	104
216	C2214	104
217	C2215	104
218	C2216	104
219	C2217	104
220	C2218	104
221	C2219	104
222	C2220	104
223	C2221	104
224	C2222	104
225	C2223	104
226	C2224	104
227	C2225	104
228	C2226	104
229	C2227	104
230	C2228	105
231	C2229	105
232	C2230	105
233	C2231	105
234	C2232	105
235	C2233	105
236	C2234	105
237	C2235	105
238	C2236	105
239	C2237	105
240	C2238	105
241	C2239	105
242	C2240	105
243	C2241	105
244	C2242	105
245	C2243	105
246	C2244	105
247	C2245	105
248	C2246	105
249	C2247	105
250	C2248	105
251	C2249	105
252	C2250	105
253	C2251	105
254	C2252	105
255	C2253	105
256	C2254	105
257	C2255	105
258	C2256	105
259	C2257	105
260	C2258	105
261	C2259	105
262	C2260	105
263	C2261	105
264	C2262	105
265	C2263	105
266	C2264	105
267	C2265	105
268	C2266	105
269	C2267	105
270	C2268	105
271	C2269	105
272	C2270	105
273	C2271	105
274	C2272	105
275	C2273	105
276	C2274	105
277	C2275	105
278	C2276	105
279	C2277	105
280	C2278	105
281	C2279	105
282	C2280	105
283	C2281	105
284	C2282	105
285	C2283	105
286	C2284	105
287	C2285	105
288	C2286	105
289	C2287	105
290	C2288	105
291	C2289	105
292	C2290	105
293	C2291	105
294	C2292	105
295	C2293	105
296	C2294	105
297	C2295	105
298	C2296	105
299	C2297	105
300	C2298	105
301	C2299	105
302	C2300	105
303	C2301	105
304	C2302	105
305	C2303	105
306	C2304	105
307	C2305	105
308	C2306	105
309	C2307	105
310	C2308	105
311	C2309	105
312	C2310	105
313	C2311	105
314	C2312	105
315	C2313	105
316	C2314	105
317	C2315	105
318	C2316	105
319	C2317	105
320	C2318	105
321	C2319	105
322	C2320	105
323	C2321	105
324	C2322	105
325	C2323	105
326	C2324	105
327	C2325	105
328	C2326	105
329	C2327	105
330	C2328	105
331	C2329	105
332	C2330	105
333	C2331	105
334	C2332	105
335	C2333	105
336	C2334	105
337	C2335	105
338	C2336	105
339	C2337	105
340	C2338	105
341	C2339	101
342	C2340	101
343	C2341	101
344	C2342	101
345	C2343	101
346	C2344	101
347	C2345	101
348	C2346	101
349	C2347	101
350	C2348	101
351	C2349	101
352	C2350	101
353	C2351	101
354	C2352	101
355	C2353	101
356	C2354	101
357	C2355	101
358	C2356	101
359	C2357	101
360	C2358	101
361	C2359	101
362	C2360	101
363	C2361	101
364	C2362	101
365	C2363	101
366	C2364	101
367	C2365	101
368	C2366	101
369	C2367	101
370	C2368	101
371	C2369	101
372	C2370	101
373	C2371	101
374	C2372	101
375	C2373	101
376	C2374	101
377	C2375	101
378	C2376	101
379	C2377	101
380	C2378	101
381	C2379	101
382	C2380	101
383	C2381	101
384	C2382	101
385	C2383	101
386	C2384	101
387	C2385	101
388	C2386	101
389	C2387	101
390	C2388	101
391	C2389	101
392	C2390	101
393	C2391	101
394	C2392	101
395	C2393	101
396	C2394	101
397	C2395	101
398	C2396	101
399	C2397	101
400	C2398	101
401	C2399	102
402	C2400	102
403	C2401	102
404	C2402	102
405	C2403	102
406	C2404	102
407	C2405	102
408	C2406	102
409	C2407	102
410	C2408	102
411	C2409	103
412	C2410	103
413	C2411	103
414	C2412	102
415	C2413	103
416	C2414	102
417	C2415	103
418	C2416	102
419	C2417	103
420	C2418	101
421	C2419	104
422	C2420	104
423	C2421	104
424	C2422	104
425	C2423	101
426	C2424	101
427	C2425	101
428	C2426	101
429	C2427	101
430	C2428	101
431	C2429	101
432	C2430	101
433	C2431	101
434	C2432	101
435	C2433	101
436	C2434	101
437	C2435	101
438	C2436	101
439	C2437	101
440	C2438	102
441	C2439	102
442	C2440	102
443	C2441	102
444	C2442	102
445	C2443	102
446	C2444	102
447	C2445	102
448	C2446	102
449	C2447	102
450	C2448	102
451	C2449	102
452	C2450	102
453	C2451	102
454	C2452	102
455	C2453	102
456	C2454	102
457	C2455	102
458	C2456	102
459	C2457	103
460	C2458	103
461	C2459	103
462	C2460	103
463	C2461	103
464	C2462	103
465	C2463	103
466	C2464	103
467	C2465	103
468	C2466	103
469	C2467	103
470	C2468	103
471	C2469	103
472	C2470	103
473	C2471	103
474	C2472	103
475	C2473	103
476	C2474	103
477	C2475	103
478	C2476	103
479	C2477	103
480	C2478	103
481	C2479	103
482	C2480	103
483	C2481	103
484	C2482	103
485	C2483	103
486	C2484	102
487	C2485	102
488	C2486	102
489	C2487	102
490	C2488	102
491	C2489	102
492	C2490	102
493	C2491	102
494	C2492	102
495	C2493	102
496	C2494	102
497	C2495	102
498	C2496	102
499	C2497	102
500	C2498	102
501	C2499	102
502	C2500	102
503	C2501	102
504	C2502	102
505	C2503	102
506	C2504	102
507	C2505	101
508	C2506	101
509	C2507	101
510	C2508	101
511	C2509	101
512	C2510	105
513	C2511	105
514	C2512	105
515	C2513	105
516	C2514	105
517	C2515	105
518	C2516	105
519	C2517	105
520	C2518	105
521	C2519	105
522	C2520	105
523	C2521	105
524	C2522	105
525	C2523	105
526	C2524	105
527	C2525	105
528	C2526	105
529	C2527	105
\.


--
-- Name: coupons_form_deal_number_seq; Type: SEQUENCE SET; Schema: public; Owner: liuyuwen_2018152068
--

SELECT pg_catalog.setval('public.coupons_form_deal_number_seq', 1, false);


--
-- Name: sign_up_form_sign_up_number_seq; Type: SEQUENCE SET; Schema: public; Owner: liuyuwen_2018152068
--

SELECT pg_catalog.setval('public.sign_up_form_sign_up_number_seq', 1, false);


--
-- Name: coupons_form coupons_form_pkey; Type: CONSTRAINT; Schema: public; Owner: liuyuwen_2018152068
--

ALTER TABLE ONLY public.coupons_form
    ADD CONSTRAINT coupons_form_pkey PRIMARY KEY (deal_number);


--
-- Name: customer_form customer_form_pkey; Type: CONSTRAINT; Schema: public; Owner: liuyuwen_2018152068
--

ALTER TABLE ONLY public.customer_form
    ADD CONSTRAINT customer_form_pkey PRIMARY KEY (customer_number);


--
-- Name: sign_up_form sign_up_form_pkey; Type: CONSTRAINT; Schema: public; Owner: liuyuwen_2018152068
--

ALTER TABLE ONLY public.sign_up_form
    ADD CONSTRAINT sign_up_form_pkey PRIMARY KEY (sign_up_number);


--
-- Name: sign_up_form sign_up_form_customer_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: liuyuwen_2018152068
--

ALTER TABLE ONLY public.sign_up_form
    ADD CONSTRAINT sign_up_form_customer_number_fkey FOREIGN KEY (customer_number) REFERENCES public.customer_form(customer_number);


--
-- Name: sign_up_form sign_up_form_deal_number_fkey; Type: FK CONSTRAINT; Schema: public; Owner: liuyuwen_2018152068
--

ALTER TABLE ONLY public.sign_up_form
    ADD CONSTRAINT sign_up_form_deal_number_fkey FOREIGN KEY (deal_number) REFERENCES public.coupons_form(deal_number);


--
-- PostgreSQL database dump complete
--

