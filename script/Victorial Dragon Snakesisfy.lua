--Victorial Dragon Snakesisfy
function c101010413.initial_effect(c)
	--enhance summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c101010413.sprcon)
	e0:SetOperation(c101010413.sprop)
	e0:SetValue(0x7327)
	c:RegisterEffect(e0)
	--If this card is Relay Summoned: You can target 1 other monster you control; shuffle it into the Deck, and if you do, draw 2 cards, then if you do not have a face-up Relay Monster in your Extra Deck, it becomes the End Phase of this turn.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(function(e,se,ep,st) return bit.band(st,0x7327)==0x7327 end)
	e1:SetTarget(c101010413.target)
	e1:SetOperation(c101010413.operation)
	c:RegisterEffect(e1)
	--When a monster you control is destroyed by battle: You can dispose 1 of this card's Points; Special Summon 1 monster from your Deck with the same Level as the destroyed monster in face-up Attack Position.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(2)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(1)
	e2:SetCondition(c101010413.con)
	e2:SetCost(c101010413.cost)
	e2:SetTarget(c101010413.tg)
	e2:SetOperation(c101010413.op)
	c:RegisterEffect(e2)
	--Do Not Remove
	local point=Effect.CreateEffect(c)
	point:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	point:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	point:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	point:SetRange(0xff)
	point:SetCountLimit(1)
	point:SetOperation(c101010413.ipoint)
	c:RegisterEffect(point)
	--redirect (Do Not Remove)
	local ge0=Effect.CreateEffect(c)
	ge0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ge0:SetCode(EFFECT_SEND_REPLACE)
	ge0:SetRange(LOCATION_ONFIELD)
	ge0:SetTarget(c101010413.reen)
	ge0:SetOperation(c101010413.reenop)
	c:RegisterEffect(ge0)
	--counter (Do Not Remove)
	if not relay_check then
		relay_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c101010413.recount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c101010413.recheck)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_BATTLED)
		ge3:SetOperation(c101010413.recount2)
		Duel.RegisterEffect(ge3,0)
	end
	--relay summon (Do Not Remove)
	local ge4=Effect.CreateEffect(c)
	ge4:SetDescription(aux.Stringid(101010401,4))
	ge4:SetType(EFFECT_TYPE_FIELD)
	ge4:SetCode(EFFECT_SPSUMMON_PROC_G)
	ge4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	ge4:SetRange(LOCATION_EXTRA)
	ge4:SetCountLimit(1,10001000)
	ge4:SetCondition(c101010413.rescon)
	ge4:SetOperation(c101010413.resop)
	ge4:SetValue(0x8773)
	c:RegisterEffect(ge4)
	--check collected points (Do Not Remove)
	local ge5=Effect.CreateEffect(c)
	ge5:SetDescription(aux.Stringid(101010401,2))
	ge5:SetType(EFFECT_TYPE_IGNITION)
	ge5:SetRange(LOCATION_MZONE)
	ge5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_BOTH_SIDE)
	ge5:SetTarget(c101010413.pointchk)
	ge5:SetOperation(c101010413.point)
	c:RegisterEffect(ge5)
	--identifier (Do Not Remove)
	local ge6=Effect.CreateEffect(c)
	ge6:SetType(EFFECT_TYPE_SINGLE)
	ge6:SetCode(10001000)
	c:RegisterEffect(ge6)
end
function c101010413.ipoint(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(10001100)==0 then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,1,aux.Stringid(101010401,1))
	end
end
function c101010413.pointchk(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(10001100)>0 and not c:IsStatus(STATUS_CHAINING) end
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c101010413.point(e,tp,eg,ep,ev,re,r,rp)
	Debug.ShowHint("Number of Points: " .. tostring(e:GetHandler():GetFlagEffectLabel(10001100)))
end
function c101010413.reen(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return bit.band(c:GetDestination(),LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)~=0 end
	if c:GetDestination()==LOCATION_GRAVE then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_TO_DECK)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.SendtoGrave(e:GetHandler(),REASON_RULE) end)
		c:RegisterEffect(e1)
	end
	Duel.PSendtoExtra(c,c:GetOwner(),r)
	return true
end
function c101010413.recount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,ct+1)
	else
		tc:RegisterFlagEffect(10001000,RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c101010413.recheck(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(10001000)
	if ct then
		tc:SetFlagEffectLabel(10001000,0)
	end
end
function c101010413.recount2(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,10001000,RESET_PHASE+PHASE_END,0,1)
end
function c101010413.resfilter(c)
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then return false end
	return c:GetFlagEffect(10001000)>0 and c:GetFlagEffectLabel(10001000)>0 and c:IsAbleToDeck() and not (c:IsType(TYPE_PENDULUM) and c:IsHasEffect(10001000))
end
function c101010413.rescon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c101010413.resfilter,tp,0xbe,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=-g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE) then return false end
	return g:GetCount()>0 and Duel.IsExistingMatchingCard(c101010413.refilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c101010413.fdfilter(c)
	return c:IsFacedown() or c:IsLocation(LOCATION_HAND)
end
function c101010413.refilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
	and not c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsForbidden()
end
function c101010413.refilter1(c,e,tp)
	return not c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c101010413.refilter(c,e,tp)
end
function c101010413.refilter2(c,e,tp)
	return c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c101010413.refilter(c,e,tp)
end
function c101010413.resop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local g=Duel.GetMatchingGroup(c101010413.resfilter,tp,0xbe,0,nil)
	local fg=g:Filter(c101010413.fdfilter,nil)
	if fg:GetCount()>0 then Duel.ConfirmCards(1-tp,fg) end
	local mg=g:Clone()
	local pt2=0
	while mg:GetCount()>0 do
		local tc=mg:Select(tp,1,1,nil)
		pt2=pt2+1
		Duel.SendtoDeck(tc,tp,1,REASON_MATERIAL+0x8773)
		mg:Sub(tc)
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsExistingMatchingCard(c101010413.refilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(101010401,5)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=Duel.SelectMatchingCard(tp,c101010413.refilter1,tp,LOCATION_EXTRA,0,1,ft,nil,e,tp)
		sg:Merge(rg)
	end
	if (not rg or ft>rg:GetCount()) and Duel.IsExistingMatchingCard(c101010413.refilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) and (not rg or Duel.SelectYesNo(tp,aux.Stringid(101010401,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local pc=Duel.SelectMatchingCard(tp,c101010413.refilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		sg:Merge(pc)
	end
	local sc=sg:GetFirst()
	while sc do
		sc:SetMaterial(g)
		local pt1=Duel.GetFlagEffect(tp,10001000)
		local e1=Effect.CreateEffect(sc)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetLabel(pt1+pt2)
		e1:SetOperation(c101010413.pointop)
		sc:RegisterEffect(e1)
		sc=sg:GetNext()
	end
end
function c101010413.pointop(e,tp,eg,ep,ev,re,r,rp)
	local pt=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	if not point then
		c:RegisterFlagEffect(10001100,0,EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE,1,pt,aux.Stringid(101010401,0))
	else
		c:SetFlagEffectLabel(10001100,point+pt)
	end
end
function c101010413.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local c=e:GetHandler()
	local point=c:GetFlagEffectLabel(10001100)
	local m=c:GetMaterial():IsExists(Card.IsCode,1,nil,101010413)
	if chk==0 then return c:GetFlagEffect(10001100)>=ct or m end
	if m then return end
	if point==ct then
		c:ResetFlagEffect(10001100)
	else
		c:SetFlagEffectLabel(10001100,point-ct)
	end
	Debug.ShowHint(tostring(ct) .. " Point(s) removed")
end
function c101010413.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c101010413.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101010413.cfilter,1,nil,tp)
end
function c101010413.filter(c,e,tp,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010413.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount()>0
		and Duel.IsExistingMatchingCard(c101010413.filter,tp,LOCATION_DECK,0,1,nil,e,tp,tc:GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010413.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010413.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg:GetFirst():GetLevel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c101010413.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsAbleToDeck() end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c101010413.rechk(c)
	return c:IsFaceup() and c:IsHasEffect(10001000)
end
function c101010413.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) and Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)~=0 and tg:IsLocation(LOCATION_DECK+LOCATION_EXTRA) then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,2,REASON_EFFECT)
		if not Duel.IsExistingMatchingCard(c101010413.rechk,tp,LOCATION_EXTRA,0,1,nil) then
			Duel.BreakEffect()
			Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetCode(EFFECT_CANNOT_BP)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c101010413.sprfilter(c)
	return c:GetEquipGroup():IsExists(Card.IsAbleToGrave,1,nil) and c:IsAbleToGrave()
end
function c101010413.sprcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return false end
	return Duel.IsExistingMatchingCard(c101010413.sprfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101010413.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c101010413.sprfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	mg:AddCard(tc)
	local qg=tc:GetEquipGroup()
	if qg:FilterCount(Card.IsAbleToGrave,nil)>1 then
		qg=qg:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
	end
	mg:Merge(qg)
	c:SetMaterial(mg)
	Duel.SendtoGrave(qg,REASON_MATERIAL)
	Duel.SendtoGrave(tc,REASON_MATERIAL)
end
