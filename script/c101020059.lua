--Aggecko Kimbu
function c101020059.initial_effect(c)
	--bounce
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,101020059)
	e1:SetTarget(c101020059.tdtg)
	e1:SetOperation(c101020059.tdop)
	c:RegisterEffect(e1)
	--xyz effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c101020059.xyzcon)
	e2:SetTarget(c101020059.xyztg)
	e2:SetOperation(c101020059.xyzop)
	c:RegisterEffect(e2)
--  --special summon
--  local e3=Effect.CreateEffect(c)
--  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
--  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
--  e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
--  e3:SetCode(EVENT_BATTLE_DESTROYING)
--  e3:SetCountLimit(1)
--  e3:SetCondition(c101020059.spcon)
--  e3:SetCost(c101020059.spcost)
--  e3:SetTarget(c101020059.sptg)
--  e3:SetOperation(c101020059.spop)
--  c:RegisterEffect(e3)
end
function c101020059.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c101020059.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c101020059.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101020059.tdfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c101020059.tdfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c101020059.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c101020059.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE
end
function c101020059.mfilter(c)
	return c:IsRace(RACE_REPTILE)
end
function c101020059.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg)
end
function c101020059.xyzfilter2(c,mg,ct)
	return c:IsXyzSummonable(mg) and c.xyz_count==ct
end
function c101020059.mfilter1(c,exg)
	return exg:IsExists(c101020059.mfilter2,1,nil,c)
end
function c101020059.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c101020059.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c101020059.mfilter,tp,LOCATION_MZONE,0,nil,e)
	if chk==0 then return mg:GetCount()>0 and Duel.IsExistingMatchingCard(c101020059.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	local exg=Duel.GetMatchingGroup(c101020059.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
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
	local g=mg:Filter(c101020059.mfilter1,nil,exg)
	local mgt=Group.CreateGroup()
	local ct=0
	while not exg:IsExists(c101020059.xyzfilter2,1,nil,mgt,ct) do
		mgt=g:Select(tp,minct,maxct,nil)
		ct=mgt:GetCount()
	end
	Duel.SetTargetCard(mgt)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101020059.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local xyzg=Duel.GetMatchingGroup(c101020059.xyzfilter2,tp,LOCATION_EXTRA,0,nil,g,g:GetCount())
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
end
--function c101020059.spcon(e,tp,eg,ep,ev,re,r,rp)
--  local c=e:GetHandler()
--  local bc=c:GetBattleTarget()
--  return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
--end
--function c101020059.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
--  Duel.SendtoGrave(e:GetHandler(),REASON_COST)
--end
--function c101020059.spfilter(c,e,tp)
--  return c:IsSetCard(0x6d6) and not c:IsCode(101020059) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
--end
--function c101020059.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
--	  and Duel.IsExistingMatchingCard(c101020059.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
--  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
--end
--function c101020059.spop(e,tp,eg,ep,ev,re,r,rp)
--  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
--  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
--  local g=Duel.SelectMatchingCard(tp,c101020059.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
--  if g:GetCount()>0 then
--	  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
--  end
--end
