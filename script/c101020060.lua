--created & coded by Hiro
--Aggecko Sicron
function c101020060.initial_effect(c)
	--to deck and special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101020060)
	e1:SetTarget(c101020060.tg)
	e1:SetOperation(c101020060.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--inflict
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101020060.intg)
	e3:SetOperation(c101020060.inop)
	c:RegisterEffect(e3)
	--xyz effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c101020060.xyzcon)
	e4:SetTarget(c101020060.xyztg)
	e4:SetOperation(c101020060.xyzop)
	c:RegisterEffect(e4)
--  --special summon
--  local e5=Effect.CreateEffect(c)
--  e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
--  e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
--  e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
--  e5:SetCode(EVENT_BATTLE_DESTROYING)
--  e5:SetCountLimit(1)
--  e5:SetCondition(c101020060.spcon)
--  e5:SetCost(c101020060.spcost)
--  e5:SetTarget(c101020060.sptg)
--  e5:SetOperation(c101020060.spop)
--  c:RegisterEffect(e5)
end
function c101020060.filter(c)
	return c:IsSetCard(0x6d6) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c101020060.spfilter(c,e,tp)
	return c:IsSetCard(0x6d6) and not c:IsCode(101020060) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101020060.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101020060.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101020060.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.IsExistingTarget(c101020060.filter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101020060.filter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
end
function c101020060.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=4 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==4 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c101020060.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c101020060.intg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c101020060.inop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Damage(1-tp,tc:GetBaseAttack()/2,REASON_EFFECT)
	end
end
function c101020060.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c101020060.mfilter(c)
	return c:IsRace(RACE_REPTILE)
end
function c101020060.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c101020060.xyzfilter2(c,mg,ct)
	return c:IsXyzSummonable(mg) and c.xyz_count==ct
end
function c101020060.mfilter1(c,exg)
	return exg:IsExists(c101020060.mfilter2,1,nil,c)
end
function c101020060.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c101020060.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c101020060.mfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return mg:GetCount()>0 and Duel.IsExistingMatchingCard(c101020060.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c101020060.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	local extc=exg:GetFirst()
	local minct=99
	local maxct=0
	while extc do
		if extc.xyz_count<minct then
			minct=extc.xyz_count
		end
		if extc.xyz_count>maxct then
			maxct=extc.xyz_count
		end
		extc=exg:GetNext()
	end
	local g=mg:Filter(c101020060.mfilter1,nil,exg)
	local mgt=Group.CreateGroup()
	local ct=0
	while not exg:IsExists(c101020060.xyzfilter2,1,nil,mgt,ct) do
		mgt=g:Select(tp,minct,maxct,nil)
		ct=mgt:GetCount()
	end
	Duel.SetTargetCard(mgt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101020060.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local xyzg=Duel.GetMatchingGroup(c101020060.xyzfilter2,tp,LOCATION_EXTRA,0,nil,g,g:GetCount())
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
--function c101020060.spcon(e,tp,eg,ep,ev,re,r,rp)
--  local c=e:GetHandler()
--  local bc=c:GetBattleTarget()
--  return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
--end
--function c101020060.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
--  Duel.SendtoGrave(e:GetHandler(),REASON_COST)
--end
--function c101020060.spfilter2(c,e,tp)
--  return c:IsSetCard(0x6d6) and not c:IsCode(101020060) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
--end
--function c101020060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
--	  and Duel.IsExistingMatchingCard(c101020060.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
--  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
--end
--function c101020060.spop(e,tp,eg,ep,ev,re,r,rp)
--  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--  local g=Duel.SelectMatchingCard(tp,c101020060.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
--  if g:GetCount()>0 then
--	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
--  end
--end
